import AppTrackingTransparency
import XCTest
@testable import AppRoot

@MainActor
final class TrackingPermissionControllerTests: XCTestCase {
    @MainActor
    private final class SystemStub {
        var status = ATTrackingManager.AuthorizationStatus.notDetermined
        var completions: [@MainActor () -> Void] = []
        lazy var controller = TrackingPermissionController(
            status: { [unowned self] in self.status },
            request: { [unowned self] in self.completions.append($0) }
        )

        func update(home: Bool = true, active: Bool = true) {
            controller.update(isHomeVisible: home, isSceneActive: active)
        }
    }

    func testWaitsForVisibleHomeAndActiveScene() {
        let system = SystemStub()
        system.update(home: false, active: false)
        system.update(home: true, active: false)
        system.update(home: false, active: true)
        XCTAssertTrue(system.completions.isEmpty)
        system.update()
        XCTAssertEqual(system.completions.count, 1)
    }

    func testRepeatedAppearancesDoNotOverlapRequests() {
        let system = SystemStub()
        system.update()
        system.update()
        system.update(home: false)
        system.update()
        XCTAssertEqual(system.completions.count, 1)
        system.status = .authorized
        system.completions[0]()
        system.update()
        XCTAssertEqual(system.completions.count, 1)
    }

    func testDeterminedStatusesNeverRequest() {
        for status: ATTrackingManager.AuthorizationStatus in [.authorized, .denied, .restricted] {
            let system = SystemStub()
            system.status = status
            system.update()
            system.update(active: false)
            system.update()
            XCTAssertTrue(system.completions.isEmpty, "Unexpected request for \(status)")
        }
    }

    func testInterruptedRequestCanRetryWhenActivationFollowsCompletion() {
        let system = SystemStub()
        system.update()
        system.update(active: false)
        system.completions[0]()
        XCTAssertEqual(system.completions.count, 1)
        system.update()
        XCTAssertEqual(system.completions.count, 2)
    }

    func testInterruptedRequestCanRetryWhenActivationPrecedesCompletion() {
        let system = SystemStub()
        system.update()
        system.update(active: false)
        system.update()
        system.completions[0]()
        XCTAssertEqual(system.completions.count, 2)
    }

    func testDeferredRetryRequiresHomeStillVisibleAndSceneActive() {
        for leaveHome in [true, false] {
            let system = SystemStub()
            system.update()
            system.update(active: false)
            system.update()
            system.update(home: !leaveHome, active: leaveHome)
            system.completions[0]()
            XCTAssertEqual(system.completions.count, 1)
        }
    }

    func testNotDeterminedCompletionDoesNotBusyLoop() {
        let system = SystemStub()
        system.update()
        system.completions[0]()
        XCTAssertEqual(system.completions.count, 1)
        system.update(home: false)
        system.update()
        XCTAssertEqual(system.completions.count, 2)
    }

    func testDeferredRetryIsBoundedEvenIfItAlsoInterruptsTheScene() {
        let system = SystemStub()
        system.update()
        system.update(active: false)
        system.update()
        system.completions[0]()
        system.update(active: false)
        system.update()
        system.completions[1]()
        XCTAssertEqual(system.completions.count, 2)
        // A later visit remains eligible; no permanent 'already asked' flag.
        system.update(home: false)
        system.update()
        XCTAssertEqual(system.completions.count, 3)
    }

    func testSystemSettingsAreReadAgainAfterReturning() {
        let system = SystemStub()
        // Global requests disabled, or an earlier denial: no prompt.
        system.status = .denied
        system.update()
        XCTAssertTrue(system.completions.isEmpty)
        system.update(active: false)
        system.status = .notDetermined
        system.update()
        XCTAssertEqual(system.completions.count, 1)
        system.status = .authorized
        system.completions[0]()
        system.update(active: false)
        system.status = .denied
        system.update()
        XCTAssertEqual(system.completions.count, 1)
    }
}
