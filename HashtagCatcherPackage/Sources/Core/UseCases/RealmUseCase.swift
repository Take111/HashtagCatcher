//
//  RealmUseCase.swift
//
//
//  Created by 竹ノ内愛斗 on 2024/09/20.
//

import Foundation
import Dependencies
import Models
import Repositories

package struct RealmUseCase {
    var createHashTagGroup: (_ group: HashTagGroupDoc) -> Void
    var createHashTagGroups: () -> [HashTagGroupDoc]
    var deleteHashTagGroup: (_ group: HashTagGroupDoc) throws -> Void
}

extension RealmUseCase: DependencyKey {
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
    var realmUseCase: RealmUseCase {
        get { self[RealmUseCase.self] }
        set { self[RealmUseCase.self] = newValue }
    }
}
