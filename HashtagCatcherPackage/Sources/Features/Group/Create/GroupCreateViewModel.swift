//
//  GroupCreateViewModel.swift
//
//
//  Created by 竹ノ内愛斗 on 2024/09/18.
//

import Foundation
import Observation
import Dependencies
import UseCases
import Models

@MainActor
@Observable
final class GroupCreateViewModel {

    @ObservationIgnored
    @Dependency(\.hashTagGroupUseCase) private var useCase

    func onTapSaveButton(groupName: String, hashTags: String) {
        let group = HashTagGroupDoc(name: groupName, tags: hashTags, createdAt: Date())
        useCase.createHashTagGroup(group)
    }
}
