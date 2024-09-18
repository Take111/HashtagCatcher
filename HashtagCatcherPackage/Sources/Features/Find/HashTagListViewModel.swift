//
//  HashTagListViewModel.swift
//
//
//  Created by 竹ノ内愛斗 on 2024/09/18.
//

import Foundation

final class HashTagListViewModel: ObservableObject {
    @Published var hashTagType: HashTagType
    @Published var hashTags: [HashTag] = []

    init(hashTagType: HashTagType) {
        self.hashTagType = hashTagType
    }

    func onApper() {
        if hashTagType == .popular {
     //       bind()
        } else {
            hashTags = hashTagType.hastTags.map { $0 }
        }
    }
}
