//
//  HashTagListViewModel.swift
//
//
//  Created by 竹ノ内愛斗 on 2024/09/18.
//

import Foundation
import Routing
import UseCases
import Dependencies

@MainActor
@Observable
final class HashTagListViewModel {
    let hashTagType: HashTagType
    var hashTags: [HashTag] = []

    @ObservationIgnored
    @Dependency(\.pasteBoardUseCase) private var pasteBoardUseCase: PasteBoardUseCase

    init(hashTagType: HashTagType) {
        self.hashTagType = hashTagType
    }

    func onApper() {
        hashTags = hashTagType.hastTags.map { $0 }
    }

    func didSelectHashTag(_ hashTag: HashTag) {
        pasteBoardUseCase.pastText(hashTag.title)
    }

    func groupDraft(for selection: Set<HashTag.ID>) -> GroupDraft {
        let tags = hashTags.filter { selection.contains($0.id) }.map { "#\($0.title)" }
        return GroupDraft(name: hashTagType.rawValue, hashtags: tags.joined(separator: " "))
    }
}
