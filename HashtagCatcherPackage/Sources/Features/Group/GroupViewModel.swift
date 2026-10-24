//
//  GroupViewModel.swift
//
//
//  Created by 竹ノ内愛斗 on 2024/09/18.
//

import Foundation
import Dependencies
import UseCases
import Models

@MainActor
@Observable
final class GroupViewModel {

    @ObservationIgnored
    @Dependency(\.hashTagGroupUseCase) private var useCase
    private(set) var groups = [HashTagGroupDoc]()

    func onAppear() {
        groups = []
        fetchGroups()
    }

    func clearAndFetchGroup() {
        groups = []
        fetchGroups()
    }

    func deleteGroup(_ group: HashTagGroupDoc) {
        do {
            try useCase.deleteHashTagGroup(group)
            fetchGroups()
        } catch {
            print("Failed to delete group: \(error)")
        }
    }

    private func fetchGroups() {
        groups = useCase.fetchHashTagGroups()
    }
}
