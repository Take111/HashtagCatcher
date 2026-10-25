//
//  FindViewModel.swift
//
//
//  Created by 竹ノ内愛斗 on 2024/09/18.
//

import Foundation

@MainActor
@Observable
final class FindViewModel {
    let types = HashTagType.allCases.map { $0 }
}
