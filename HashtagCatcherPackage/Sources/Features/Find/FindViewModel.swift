//
//  FindViewModel.swift
//
//
//  Created by 竹ノ内愛斗 on 2024/09/18.
//

import Foundation
import Combine

final class FindViewModel: ObservableObject {
    let types = HashTagType.allCases.map { $0 }
}
