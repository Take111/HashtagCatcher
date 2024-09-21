//
//  HashTagGroupUseCase.swift
//
//
//  Created by 竹ノ内愛斗 on 2024/09/20.
//

import Foundation
import Dependencies
import Models
import Repositories

package struct HashTagGroupUseCase {
    package var createHashTagGroup: (_ group: HashTagGroupDoc) -> Void
    package var createHashTagGroups: () -> [HashTagGroupDoc]
    package var deleteHashTagGroup: (_ group: HashTagGroupDoc) throws -> Void
}

extension HashTagGroupUseCase: DependencyKey {
    package static var liveValue: Self {
        @Dependency(\.realmRepository) var realmRepository
        return Self(
            createHashTagGroup: { group in
                realmRepository.write(object: group)
            },
            createHashTagGroups: {
                realmRepository.readAll()
            },
            deleteHashTagGroup: { group in
                try realmRepository.delete(object: group)
            }
        )
    }
}

package extension DependencyValues {
    var hashTagGroupUseCase: HashTagGroupUseCase {
        get { self[HashTagGroupUseCase.self] }
        set { self[HashTagGroupUseCase.self] = newValue }
    }
}
