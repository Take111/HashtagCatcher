import SwiftUI

/// A screen in another feature. Features request it through `\.route`; `AppRootView` decides how to show it.
package enum AppRoute {
    case createGroup(GroupDraft)
}

package struct GroupDraft: Identifiable {
    package let id = UUID()
    package var name: String
    package var hashtags: String

    package init(name: String = "", hashtags: String = "") {
        self.name = name
        self.hashtags = hashtags
    }
}

package struct RouteAction {
    private let handler: (AppRoute) -> Void

    package init(_ handler: @escaping (AppRoute) -> Void) {
        self.handler = handler
    }

    package func callAsFunction(_ route: AppRoute) {
        handler(route)
    }
}

package extension EnvironmentValues {
    @Entry var route = RouteAction { _ in }
}
