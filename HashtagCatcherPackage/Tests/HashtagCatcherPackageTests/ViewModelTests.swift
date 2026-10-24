import XCTest
import Dependencies
import Models
@testable import UseCases
@testable import FindFeature
@testable import GroupFeature

@MainActor
final class ViewModelTests: XCTestCase {
    private let date = Date(timeIntervalSince1970: 1_700_000_000)

    func testGroupViewModelLoadsAndDeletesGroups() {
        var stored = [
            HashTagGroupDoc(name: "Travel", tags: "#旅行", createdAt: date),
            HashTagGroupDoc(name: "Food", tags: "#food", createdAt: date)
        ]
        let viewModel = withDependencies {
            $0.hashTagGroupUseCase = HashTagGroupUseCase(
                createHashTagGroup: { stored.append($0) },
                fetchHashTagGroups: { stored },
                deleteHashTagGroup: { group in stored.removeAll { $0.id == group.id } }
            )
        } operation: {
            GroupViewModel()
        }

        viewModel.onAppear()
        XCTAssertEqual(viewModel.groups.map(\.name), ["Travel", "Food"])

        viewModel.deleteGroup(viewModel.groups[0])
        XCTAssertEqual(viewModel.groups.map(\.name), ["Food"])
    }

    func testGroupCreateViewModelSavesGroup() {
        var created: [HashTagGroupDoc] = []
        let viewModel = withDependencies {
            $0.hashTagGroupUseCase = HashTagGroupUseCase(
                createHashTagGroup: { created.append($0) },
                fetchHashTagGroups: { [] },
                deleteHashTagGroup: { _ in }
            )
        } operation: {
            GroupCreateViewModel()
        }

        viewModel.onTapSaveButton(groupName: "Travel", hashTags: "#旅行 #travel")

        XCTAssertEqual(created.count, 1)
        XCTAssertEqual(created.first?.name, "Travel")
        XCTAssertEqual(created.first?.tags, "#旅行 #travel")
        XCTAssertNotNil(created.first?.createdAt)
    }

    func testGroupEditViewModelSavesCopyWithSameIdentity() {
        let original = HashTagGroupDoc(name: "Travel", tags: "#旅行", createdAt: date)
        var saved: [HashTagGroupDoc] = []
        let viewModel = withDependencies {
            $0.hashTagGroupUseCase = HashTagGroupUseCase(
                createHashTagGroup: { saved.append($0) },
                fetchHashTagGroups: { [] },
                deleteHashTagGroup: { _ in }
            )
        } operation: {
            GroupEditViewModel(group: original)
        }

        XCTAssertEqual(viewModel.groupName, "Travel")
        XCTAssertEqual(viewModel.hashtags, "#旅行")

        viewModel.groupName = "Trip"
        viewModel.hashtags = "#trip"
        viewModel.onTapEditButton()

        XCTAssertEqual(saved.count, 1)
        XCTAssertEqual(saved.first?.id, original.id)
        XCTAssertEqual(saved.first?.name, "Trip")
        XCTAssertEqual(saved.first?.tags, "#trip")
        XCTAssertEqual(original.name, "Travel")
    }

    func testGroupEditViewModelCopiesHashtags() {
        var copied: [String] = []
        let viewModel = withDependencies {
            $0.pasteBoardUseCase = PasteBoardUseCase(pastText: { copied.append($0) })
            $0.storeReviewUseCase = StoreReviewUseCase(showStoreReview: {}, moveAppStoreReview: {})
        } operation: {
            GroupEditViewModel(group: HashTagGroupDoc(name: "Travel", tags: "#旅行 #travel", createdAt: date))
        }

        viewModel.onTapPasteButton()

        XCTAssertEqual(copied, ["#旅行 #travel"])
    }

    func testHashTagListViewModelLoadsAndCopiesHashTag() {
        var copied: [String] = []
        let viewModel = withDependencies {
            $0.pasteBoardUseCase = PasteBoardUseCase(pastText: { copied.append($0) })
        } operation: {
            HashTagListViewModel(hashTagType: .travel)
        }

        viewModel.onApper()
        XCTAssertEqual(viewModel.hashTags.map(\.title), HashTagType.travel.hastTags.map(\.title))

        viewModel.didSelectHashTag(viewModel.hashTags[0])
        XCTAssertEqual(copied, ["travel"])
    }
}
