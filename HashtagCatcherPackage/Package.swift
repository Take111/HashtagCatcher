// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

private extension PackageDescription.Target.Dependency {
    static let realm: Self = .product(name: "RealmSwift", package: "realm-swift")
}

private let features: [PackageDescription.Target.Dependency] = ["FindFeature", "GroupFeature", "SettingsFeature"]

let package = Package(
    name: "HashtagCatcherPackage",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Production",
            targets: ["ProductionApp"]),
        .library(
            name: "Staging",
            targets: ["StagingApp"]),
    ],
    dependencies: [
        //　本当は20.0.0を使いたいが、うまく入らない
        .package(url: "https://github.com/realm/realm-swift.git", from: "10.53.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ProductionApp",
            dependencies: features,
            path: "./Sources/Apps/Production"
        ),
        .target(
            name: "StagingApp",
            dependencies: features,
            path: "./Sources/Apps/Staging"
        ),
        .target(
            name: "FindFeature",
            dependencies: ["UIComponents", "UseCases"],
            path: "./Sources/Features/Find"
        ),
        .target(
            name: "GroupFeature",
            dependencies: ["UIComponents", "UseCases"],
            path: "./Sources/Features/Group"
        ),
        .target(
            name: "SettingsFeature",
            dependencies: ["UIComponents", "UseCases"],
            path: "./Sources/Features/Settings"
        ),
        .target(
            name: "UIComponents",
            path: "./Sources/Core/UIComponents"
        ),
        .target(
            name: "UseCases",
            dependencies: ["Models", "Repositories"],
            path: "./Sources/Core/UseCases"
        ),
        .target(
            name: "Models",
            path: "./Sources/Core/Models"
        ),
        .target(
            name: "Repositories",
            dependencies: [.realm, "APIService"],
            path: "./Sources/Core/Repositories"
        ),
        .target(
            name: "APIService",
            path: "./Sources/Core/APIService"
        )
    ]
)
