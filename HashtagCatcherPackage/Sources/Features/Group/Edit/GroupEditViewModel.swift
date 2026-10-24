//
//  GroupEditViewModel.swift
//
//
//  Created by 竹ノ内愛斗 on 2024/09/18.
//

import Foundation
import Dependencies
import Models
import UseCases

@MainActor
@Observable
final class GroupEditViewModel {
    var groupName: String = ""
    var hashtags: String = ""

    @ObservationIgnored
    @Dependency(\.hashTagGroupUseCase) private var hashTagGroupUseCase
    @ObservationIgnored
    @Dependency(\.pasteBoardUseCase) private var pasteBoardUseCase
    @ObservationIgnored
    @Dependency(\.storeReviewUseCase) private var storeReviewUseCase

    private let group: HashTagGroupDoc

    init(group: HashTagGroupDoc) {
        self.group = group
        self.groupName = group.name
        self.hashtags = group.tags
    }

    func onTapPasteButton() {
        pasteBoardUseCase.pastText(hashtags)

        if Bool.random() {
            storeReviewUseCase.showStoreReview()
        }
    }

    func onTapEditButton() {
        guard let copiedDoc = group.copy(with: nil) as? HashTagGroupDoc else { return }
        copiedDoc.name = groupName
        copiedDoc.tags = hashtags
        hashTagGroupUseCase.createHashTagGroup(copiedDoc)
    }
}
