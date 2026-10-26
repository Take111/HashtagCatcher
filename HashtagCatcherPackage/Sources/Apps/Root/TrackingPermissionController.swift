import AppTrackingTransparency

/// Permission preparation only: this type never starts tracking or an advertising SDK.
@MainActor
final class TrackingPermissionController {
    typealias Status = ATTrackingManager.AuthorizationStatus

    private let status: () -> Status
    private let request: (@escaping @MainActor () -> Void) -> Void
    private var isEligible = false
    private var isRequestInFlight = false
    private var becameEligibleDuringRequest = false

    init(
        status: @escaping () -> Status = { ATTrackingManager.trackingAuthorizationStatus },
        request: @escaping (@escaping @MainActor () -> Void) -> Void = { completion in
            ATTrackingManager.requestTrackingAuthorization { _ in
                Task { @MainActor in completion() }
            }
        }
    ) {
        self.status = status
        self.request = request
    }

    func update(isHomeVisible: Bool, isSceneActive: Bool) {
        let wasEligible = isEligible
        isEligible = isHomeVisible && isSceneActive
        if isRequestInFlight {
            if isEligible && !wasEligible { becameEligibleDuringRequest = true }
            return
        }
        requestIfEligible(allowDeferredRetry: true)
    }

    private func requestIfEligible(allowDeferredRetry: Bool) {
        // Read the system value each time, including after a change in Settings.
        guard isEligible, status() == .notDetermined else { return }
        isRequestInFlight = true
        becameEligibleDuringRequest = false
        request { [weak self] in
            guard let self else { return }
            self.isRequestInFlight = false
            // Activation can arrive before an interrupted request's completion.
            // Retry at most once here; an immediate notDetermined result must not loop.
            if allowDeferredRetry && self.becameEligibleDuringRequest {
                self.requestIfEligible(allowDeferredRetry: false)
            }
        }
    }
}
