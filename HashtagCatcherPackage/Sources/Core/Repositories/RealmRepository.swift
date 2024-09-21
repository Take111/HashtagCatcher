//
//  RealmRepository.swift
//
//
//  Created by 竹ノ内愛斗 on 2024/09/20.
//

import Foundation
import RealmSwift
import Dependencies

package struct RealmRepositoryKey: DependencyKey {
    package static let liveValue: RealmRepository = RealmRepositoryImpl()
}

package extension DependencyValues {
    var realmRepository: RealmRepository {
        get { self[RealmRepositoryKey.self] }
        set { self[RealmRepositoryKey.self] = newValue }
    }
}

package protocol RealmRepository {
    func write(object: Object)
    func readAll<T: Object>() -> [T]
    func delete<T: Object>(object: T) throws
}

final class RealmRepositoryImpl: RealmRepository, ObservableObject {
    private let realm: Realm

    // swiftlint:disable force_try
    init(_ realm: Realm = try! Realm()) {
        self.realm = realm
    }

    // swiftlint:disable force_try
    func write(object: Object) {
        try! realm.write {
            realm.add(object, update: .all)
        }
    }

    func readAll<T: Object>() -> [T] {
        Array(realm.objects(T.self))
    }

    func delete<T: Object>(object: T) throws {
        try! realm.write {
            realm.delete(object)
        }
    }
}
