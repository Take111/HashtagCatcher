# Manual Xcode Cloud builds for TestFlight

This is repository preparation, not an activated Cloud workflow. The owner's App Store Connect access, repository connection, Cloud toolchain availability and signing remain unverified. No Cloud build or upload has run.

## Repository prerequisites

PR #19 supplies the Xcode 27 compatibility changes and shared schemes; this PR is stacked on it. The current default branch is `develop`, but the intended Cloud distribution source is **`main`**. Both PRs' reviewed changes must reach `main` through the normal release process before setup. Today's `main` does not yet contain these prerequisites. This guide changes neither the default branch nor merge policy.

| Setting | Verified value |
| --- | --- |
| Workspace | Root `HashtagCatcher.xcworkspace` |
| Scheme | Shared `ProductionApp` in `App/Production.xcodeproj/xcshareddata/xcschemes/` |
| Archive | Production target, Release configuration, iOS destination |
| Signing | Automatic; team `DQ6L6A5H88` |
| Bundle / App Store ID | `ChikatoTakenouchi.HashtagCatcher` / `1568648119` |
| Toolchain | `.xcode-version`: 27.0; locally tested build 27A266a |
| Minimum iOS | App 17.5; package 17 |

SwiftPM uses the local package and public dependencies, with the workspace's `xcshareddata/swiftpm/Package.resolved` committed. There is no generated project, private dependency or CocoaPods/Carthage bootstrap requiring a `ci_scripts` hook, so none is added. Keep the lockfile updated with dependency changes. See Apple's [project prerequisites](https://developer.apple.com/documentation/xcode/setting-up-your-project-to-use-xcode-cloud) and [dependency guidance](https://developer.apple.com/documentation/xcode/making-dependencies-available-to-xcode-cloud).

The shared Production scheme's Test action is empty: Archive does not run the package tests. The existing secretless GitHub simulator CI runs those tests; require it to pass for the reviewed release commit.

## Setup after separate authorization

1. Open the workspace in Xcode and select the Production app for Xcode Cloud, or inspect its existing Cloud product in App Store Connect. Confirm the app/team above. Repository connection, access grants and agreement acceptance require the owner's action; public GitHub visibility does not establish a Cloud connection.
2. Choose **Xcode 27.0** and a compatible macOS in the Cloud environment. The repository's `.xcode-version` does not select this automatically. Confirm 27.0 is offered in the owner's account; local/GitHub availability is not proof of Cloud availability. Stop and review if it is unavailable.
3. Set the sole start condition to **Manual Start**, restricted to the exact **`main` branch**. Do not add branch-change, PR, tag or schedule triggers, or permit arbitrary refs. Inspect the reviewed main commit before starting it. See [start conditions](https://developer.apple.com/documentation/xcode/configuring-start-conditions).
4. Add an iOS **Archive** action using `ProductionApp` / Release, with **TestFlight and App Store** deployment preparation. Use Cloud's automatic signing; no GitHub signing secrets or upload script is needed. Follow [Apple's distribution guide](https://developer.apple.com/documentation/xcode/creating-a-workflow-that-builds-your-app-for-distribution). Leave tester-group distribution/post-actions unconfigured until separately reviewed. Uploading a build does not submit an App Store version.
5. Before the first authorized run, verify that the marketing version (currently `1.3.1`) can accept a new build, Cloud's build number will not collide with a previous upload, and the Realm update passes an installed-app upgrade/data-retention smoke test. Do not accept an onboarding option that immediately starts a build without authorization.

## Who can run it

**Manual Start is not owner-only access.** Restrict Editing controls workflow edits, not an execution allowlist. No per-user execution allowlist is established by this repository.

Before activation, inspect App Store Connect **Users and Access**, Hashtag's app access, and applicable API access. Apple's current [roles table](https://developer.apple.com/help/account/access/roles/) lists full Xcode Cloud access for Account Holder, Admin and App Manager, and read-only access for Developer. Review [app access](https://developer.apple.com/help/app-store-connect/manage-your-team/edit-access-to-apps/) too; account-wide administrative privileges cannot be excluded by a workflow setting. Only claim owner-only operation after verifying the actual account. This PR changes no roles or access.

Do not run unreviewed PR/fork code with signing privileges. Protect and review source reaching `main`; anyone able to replace trusted source or edit Cloud configuration can change build behavior. GitHub actor guards and Environment settings do not govern builds started directly in Xcode Cloud.

## Validation boundary

Local Xcode 27 simulator builds and two package tests pass. An unsigned generic-iOS Production Release archive also passed with Xcode 27.0 (27A266a), SDK 27.0 and minimum iOS 17.5. These prove compilation, not Cloud configuration, signing, authorization or TestFlight delivery. Follow `AGENTS.md` for local checks and verify final PR CI before release preparation.
