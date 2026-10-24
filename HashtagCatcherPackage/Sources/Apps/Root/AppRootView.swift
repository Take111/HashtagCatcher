import SwiftUI
import FindFeature
import GroupFeature
import SettingsFeature
import Routing
import UIComponents

/// Tab layout shared by the Production and Staging apps; handles routes between features.
package struct AppRootView: View {
    private enum Tab: Hashable {
        case find, group, settings
    }

    @State private var selection = Tab.group
    @State private var groupDraft: GroupDraft?

    package init() {}

    package var body: some View {
        TabView(selection: $selection) {
            FindView()
                .tabItem {
                    Label("探す", systemImage: "magnifyingglass")
                }
                .tag(Tab.find)
            GroupView(createDraft: $groupDraft)
                .tabItem {
                    Label("グループ", systemImage: "person.3")
                }
                .tag(Tab.group)
            SettingsView()
                .tabItem {
                    Label("設定", systemImage: "gear")
                }
                .tag(Tab.settings)
        }
        .tint(Color(UIColor.primary))
        .environment(\.route, RouteAction { route in
            switch route {
            case let .createGroup(draft):
                selection = .group
                groupDraft = draft
            }
        })
    }
}

#Preview {
    AppRootView()
}
