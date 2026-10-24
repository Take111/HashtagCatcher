import XCTest
import Dependencies
import Models
import UseCases
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
            $0.hashTagGroupUseCase.fetchHashTagGroups = { stored }
            $0.hashTagGroupUseCase.deleteHashTagGroup = { group in stored.removeAll { $0.id == group.id } }
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
            $0.hashTagGroupUseCase.createHashTagGroup = { created.append($0) }
        } operation: {
            GroupCreateViewModel()
        }

        viewModel.onTapSaveButton(groupName: "Travel", hashTags: "#旅行 #travel")

        XCTAssertEqual(created.map(\.name), ["Travel"])
        XCTAssertEqual(created.map(\.tags), ["#旅行 #travel"])
        XCTAssertNotNil(created.first?.createdAt)
    }

    func testGroupEditViewModelSavesCopyWithSameIdentity() {
        let original = HashTagGroupDoc(name: "Travel", tags: "#旅行", createdAt: date)
        var saved: [HashTagGroupDoc] = []
        let viewModel = withDependencies {
            $0.hashTagGroupUseCase.createHashTagGroup = { saved.append($0) }
        } operation: {
            GroupEditViewModel(group: original)
        }

        XCTAssertEqual(viewModel.groupName, "Travel")
        XCTAssertEqual(viewModel.hashtags, "#旅行")

        viewModel.groupName = "Trip"
        viewModel.hashtags = "#trip"
        viewModel.onTapEditButton()

        XCTAssertEqual(saved.map(\.id), [original.id])
        XCTAssertEqual(saved.map(\.name), ["Trip"])
        XCTAssertEqual(saved.map(\.tags), ["#trip"])
        XCTAssertEqual(original.name, "Travel")
    }

    func testGroupEditViewModelCopiesHashtags() {
        var copied: [String] = []
        let viewModel = withDependencies {
            $0.pasteBoardUseCase.pastText = { copied.append($0) }
            $0.storeReviewUseCase.showStoreReview = {}
        } operation: {
            GroupEditViewModel(group: HashTagGroupDoc(name: "Travel", tags: "#旅行 #travel", createdAt: date))
        }

        viewModel.onTapPasteButton()

        XCTAssertEqual(copied, ["#旅行 #travel"])
    }

    func testHashTagListViewModelLoadsAndCopiesHashTag() {
        var copied: [String] = []
        let viewModel = withDependencies {
            $0.pasteBoardUseCase.pastText = { copied.append($0) }
        } operation: {
            HashTagListViewModel(hashTagType: .travel)
        }

        viewModel.onApper()
        XCTAssertEqual(viewModel.hashTags.map(\.title), HashTagType.travel.hastTags.map(\.title))

        viewModel.didSelectHashTag(viewModel.hashTags[0])
        XCTAssertEqual(copied, ["travel"])
    }

    func testHashTagListViewModelBuildsGroupDraftInListOrder() {
        let viewModel = HashTagListViewModel(hashTagType: .travel)
        viewModel.onApper()

        let selection: Set = [viewModel.hashTags[3].udid, viewModel.hashTags[0].udid]
        let draft = viewModel.groupDraft(for: selection)

        XCTAssertEqual(draft.name, "旅行")
        XCTAssertEqual(draft.hashtags, "#travel #海外旅行")
    }
}
