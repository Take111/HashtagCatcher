//
//  HashTagListViewModel.swift
//
//
//  Created by 竹ノ内愛斗 on 2024/09/18.
//

import Foundation
import UseCases
import Dependencies

final class HashTagListViewModel: ObservableObject {
    @Published var hashTagType: HashTagType
    @Published var hashTags: [HashTag] = []

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
}
