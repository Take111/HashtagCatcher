//
//  ProductionRootView.swift
//
//
//  Created by 竹ノ内愛斗 on 2024/09/10.
//

import SwiftUI
import FindFeature
import GroupFeature
import SettingsFeature

public struct ProductionRootView: View {

    @State private var selection = 2

    public init() {}

    public var body: some View {
        TabView(selection: $selection) {
            FindView()
                .tabItem {
                    Label("探す", systemImage: "magnifyingglass")
                }
                .tag(1)
            GroupView()
                .tabItem {
                    Label("グループ", systemImage: "folder")
                }
                .tag(2)
            SettingsView()
                .tabItem {
                    Label("設定", systemImage: "gearshape")
                }
                .tag(3)
        }
        .accentColor(Color(UIColor.primary))
    }
}
#Preview {
    ProductionRootView()
}


