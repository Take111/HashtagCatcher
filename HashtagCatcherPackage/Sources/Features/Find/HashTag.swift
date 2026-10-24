//
//  HashTag.swift
//
//
//  Created by 竹ノ内愛斗 on 2024/09/18.
//

import Foundation

struct HashTag: Identifiable {
    let title: String

    var id: String { title }
}
