//
//  GroupEditViewModel.swift
//
//
//  Created by 竹ノ内愛斗 on 2024/09/18.
//

import Foundation
import Combine

final class GroupEditViewModel: ObservableObject {
    @Published var groupName: String = ""
    @Published var hashtags: String = ""
}