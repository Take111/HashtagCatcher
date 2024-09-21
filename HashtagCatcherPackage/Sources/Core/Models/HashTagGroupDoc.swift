//
//  File.swift
//  
//
//  Created by 竹ノ内愛斗 on 2024/09/15.
//

import Foundation
import RealmSwift

package final class HashTagGroupDoc: Object, Identifiable {
    @objc dynamic package var id: String = UUID().uuidString
    @objc dynamic package var name: String = ""
    @objc dynamic package var tags: String = ""
    @objc dynamic package var createdAt: Date?
    @objc dynamic package var updatedAt: Date?

    package override static func primaryKey() -> String? {
        return "id"
    }

    convenience package init(name: String, tags: String, createdAt: Date?, updatedAt: Date? = nil) {
        self.init()
        self.name = name
        self.tags = tags
        self.createdAt = createdAt
        self.updatedAt = updatedAt ?? createdAt
    }
}

extension HashTagGroupDoc: NSCopying {
    package func copy(with zone: NSZone? = nil) -> Any {
        let value = HashTagGroupDoc()
        value.id = id
        value.name = name
        value.tags = tags
        value.createdAt = createdAt
        value.updatedAt = updatedAt
        return value
    }
}
