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
import Routing

public struct ProductionRootView: View {

    @State private var selection = 2
    @State private var groupDraft: GroupDraft?

    public init() {}

    public var body: some View {
        TabView(selection: $selection) {
            FindView()
                .tabItem {
                    Label("探す", systemImage: "magnifyingglass")
                }
                .tag(1)
            GroupView(createDraft: $groupDraft)
                .tabItem {
                    Label("グループ", systemImage: "person.3")
                }
                .tag(2)
            SettingsView()
                .tabItem {
                    Label("設定", systemImage: "gear")
                }
                .tag(3)
        }
        .tint(Color(UIColor.primary))
        .environment(\.route, RouteAction { route in
            switch route {
            case let .createGroup(draft):
                selection = 2
                groupDraft = draft
            }
        })
    }
}
#Preview {
    ProductionRootView()
}


