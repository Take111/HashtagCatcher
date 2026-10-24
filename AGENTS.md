# HashtagCatcher development guide

`CLAUDE.md` is a relative symlink to this file. Update this file as the single source of agent guidance.

## Structure

- `HashtagCatcher.xcworkspace` combines the local Swift package and both app projects.
- `App/Production.xcodeproj` and `App/Staging.xcodeproj` are the app shells; their sources and resources are under `App/HashtagCatcher/`.
- `HashtagCatcherPackage/Package.swift` declares the module graph: app roots → Find/Group/Settings features → UIComponents/UseCases → Models/Repositories/APIService.
- Realm 20 stores hashtag groups locally (the app does not use Atlas Device Sync). Preserve the model schema, primary keys, and existing user data when changing persistence.
- SwiftPM dependencies and exact resolved revisions are tracked in `HashtagCatcher.xcworkspace/xcshareddata/swiftpm/Package.resolved`.

## Toolchain and validation

Use the Xcode version pinned in `.xcode-version` and Swift 5 language mode. The app deployment target remains iOS 17.5; the reusable package targets iOS 17. Do not raise these as a workaround for build failures.
Select Xcode through `DEVELOPER_DIR` for the command/session; avoid changing the machine-wide selection.

From the repository root:

```sh
xcodebuild -workspace HashtagCatcher.xcworkspace -scheme ProductionApp -configuration Release -destination 'generic/platform=iOS Simulator' -derivedDataPath .build/DerivedData CODE_SIGNING_ALLOWED=NO build
xcodebuild -workspace HashtagCatcher.xcworkspace -scheme StagingApp -configuration Debug -destination 'generic/platform=iOS Simulator' -derivedDataPath .build/DerivedData CODE_SIGNING_ALLOWED=NO build
xcodebuild -workspace HashtagCatcher.xcworkspace -scheme HashtagCatcherPackageTests -destination 'platform=iOS Simulator,name=iPhone 17,OS=latest' -derivedDataPath .build/DerivedData CODE_SIGNING_ALLOWED=NO test
```

Use `xcrun simctl list devices available` to choose an installed iOS simulator when the example is unavailable. The package imports UIKit/SwiftUI; macOS `swift test` is not a replacement for iOS tests. Xcode generates the `HashtagCatcherPackageTests` scheme from the declared package test target. Tests exercise model copying and in-memory Realm persistence without network services or production data. There is no configured SwiftLint ruleset; avoid introducing unrelated formatting changes.

## CI and dependencies

GitHub Actions builds both app shells and runs the package tests on an iOS simulator without signing credentials. Keep workflows safe for public fork PRs: read-only permissions, no secrets, no `pull_request_target`, no deployment steps. Use pinned action commits and review dependency changes together with the resolved lockfile.

Renovate checks SwiftPM and GitHub Actions on Monday before 09:00 Asia/Tokyo, groups non-major Swift updates, and requires dashboard approval for Swift major updates. Swift ranges use `bump` so new non-major releases also generate proposals. After a Swift update, manually run `xcodebuild -resolvePackageDependencies -workspace HashtagCatcher.xcworkspace -scheme ProductionApp` and commit the workspace `Package.resolved` before running the locked CI checks; Renovate does not refresh this workspace lockfile. Auto-merge is disabled. AlertToast currently follows `master` with a locked revision; review branch changes manually. Configuration alone does not install/authorize the Renovate GitHub App: the repository owner must enable this repository in an existing installation, or explicitly install it if absent. Do not grant permissions on their behalf.

For manually started Xcode Cloud distribution, follow `docs/xcode-cloud.md`. Its setup, account access and upload are separate from repository validation. Do not activate Cloud or start a build/upload without explicit authorization.

## Scope and safety

Keep compatibility work small and preserve app behavior. Do not merge, force-push, auto-merge, submit to App Store, add deployment labels, modify credentials/security settings, or publish private context. Release uploads and signing are a separate, explicitly authorized task. Never commit local accounts, signing files, generated build output, or secrets. Run the affected builds/tests and report exact toolchain, failures, and unverified checks.
