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

    @Environment(\.scenePhase) private var scenePhase
    @State private var trackingPermission = TrackingPermissionController()
    @State private var isGroupHomeVisible = false

    @State private var selection = Tab.group
    @State private var groupDraft: GroupDraft?

    package init() {}

    package var body: some View {
        TabView(selection: $selection) {
            FindView()
                .tabItem {
                    Label(String(localized: "探す", bundle: .module), systemImage: "magnifyingglass")
                }
                .tag(Tab.find)
            GroupView(createDraft: $groupDraft, onHomeVisibilityChange: { isGroupHomeVisible = $0 })
                .tabItem {
                    Label(String(localized: "グループ", bundle: .module), systemImage: "person.3")
                }
                .tag(Tab.group)
            SettingsView()
                .tabItem {
                    Label(String(localized: "設定", bundle: .module), systemImage: "gear")
                }
                .tag(Tab.settings)
        }
        .tint(Color(UIColor.primary))
        .onChange(of: isHomeVisible, initial: true) { _, _ in
            updateTrackingPermission()
        }
        .onChange(of: scenePhase) { _, _ in
            updateTrackingPermission()
        }
        .environment(\.route, RouteAction { route in
            switch route {
            case let .createGroup(draft):
                selection = .group
                groupDraft = draft
            }
        })
    }

    private var isHomeVisible: Bool {
        selection == .group && isGroupHomeVisible && groupDraft == nil
    }

    private func updateTrackingPermission() {
        trackingPermission.update(isHomeVisible: isHomeVisible, isSceneActive: scenePhase == .active)
    }
}

#Preview {
    AppRootView()
}
