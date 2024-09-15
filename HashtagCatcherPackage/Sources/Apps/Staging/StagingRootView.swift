//
//  StagingRootView.swift
//
//
//  Created by 竹ノ内愛斗 on 2024/09/10.
//

import SwiftUI
import FindFeature
import GroupFeature
import SettingsFeature

public struct StagingRootView: View {
    public init() {
 
    }

    public var body: some View {
        TabView {
            FindView()
                .tabItem {
                    Label("Find", systemImage: "magnifyingglass")
                }
            GroupView()
                .tabItem {
                    Label("Group", systemImage: "person.3")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}
