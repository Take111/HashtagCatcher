//
//  GroupViewModel.swift
//
//
//  Created by 竹ノ内愛斗 on 2024/09/18.
//

import Foundation
import Combine
import Dependencies
import UseCases
import Models

final class GroupViewModel: ObservableObject {

    @Dependency(\.hashTagGroupUseCase) private var useCase
    @Published private(set) var groups = [HashTagGroupDoc]()

    func onAppear() {
        groups = []
        fetchGroups()
    }

    func clearAndFetchGroup() {
        groups = []
        fetchGroups()
    }

    func deleteGroup(_ group: HashTagGroupDoc) {
        try? useCase.deleteHashTagGroup(group)
        fetchGroups()
    }

    private func fetchGroups() {
        groups = useCase.fetchHashTagGroups()
    }
}
