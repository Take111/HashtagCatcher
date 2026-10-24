# Manual Xcode Cloud builds for TestFlight

This guide describes repository preparation and later Cloud setup. The App Store Connect account, repository connection, available Cloud toolchains and signing must be verified before activation. Repository changes alone do not configure Cloud or authorize a build/upload.

## Repository prerequisites

The intended Cloud distribution source is **`main`**; the repository's default branch is `develop`. Before setup, ensure that `main` contains the shared ProductionApp scheme and compatibility changes for the pinned Xcode version through the normal release process.

| Setting | Value |
| --- | --- |
| Workspace | Root `HashtagCatcher.xcworkspace` |
| Scheme | Shared `ProductionApp` in `App/Production.xcodeproj/xcshareddata/xcschemes/` |
| Signing | Automatic; team `DQ6L6A5H88` |
| Bundle / App Store ID | `ChikatoTakenouchi.HashtagCatcher` / `1568648119` |
| Toolchain | Version pinned in `.xcode-version` |

SwiftPM uses the local package and public dependencies, with the workspace's `xcshareddata/swiftpm/Package.resolved` committed. There is no generated project, private dependency or CocoaPods/Carthage bootstrap requiring a `ci_scripts` hook, so none is added. Keep the lockfile updated with dependency changes. See Apple's [project prerequisites](https://developer.apple.com/documentation/xcode/setting-up-your-project-to-use-xcode-cloud) and [dependency guidance](https://developer.apple.com/documentation/xcode/making-dependencies-available-to-xcode-cloud).

The shared Production scheme's Test action is empty: Archive does not run the package tests. Require the existing secretless GitHub simulator CI to pass for the exact `main` commit selected for Manual Start. Before promoting a release, verify that the Production target's `MARKETING_VERSION` can accept a new build and the Realm update passes an installed-app upgrade/data-retention smoke test.

## Who can run it

**Manual Start is not owner-only access.** Restrict Editing controls workflow edits, not a per-user execution allowlist. Do not claim owner-only operation without verifying the actual account.

Before activation, the Account Holder or an authorized Admin must inspect App Store Connect **Users and Access**, access to the app with ID **1568648119**, and applicable API access. Apple's current [roles table](https://developer.apple.com/help/account/access/roles/) lists full Xcode Cloud access for Account Holder, Admin and App Manager, and read-only access for Developer. Review [app access](https://developer.apple.com/help/app-store-connect/manage-your-team/edit-access-to-apps/) too; account-wide administrative privileges cannot be excluded by a workflow setting. A GitHub account name does not establish an Apple account's role.

Do not run unreviewed PR/fork code with signing privileges. Protect and review source reaching `main`; anyone able to replace trusted source or edit Cloud configuration can change build behavior. Authorization for Cloud is determined by Apple account roles and app access, not GitHub workflow settings.

## Setup after separate authorization

1. Open the workspace in Xcode and select the Production app for Xcode Cloud, or inspect its existing Cloud product in App Store Connect. Confirm the app/team above. The appropriate account administrator must authorize any repository connection, access grant or agreement acceptance; public GitHub visibility does not establish a Cloud connection. Do not accept an onboarding option that immediately starts a build without authorization.
2. Choose the exact Xcode version in **`.xcode-version`** and a compatible macOS in the Cloud environment. The file does not select Cloud's toolchain automatically. Confirm the pinned version is offered in the account; local/GitHub availability is not proof of Cloud availability. Stop and review if it is unavailable.
3. Set the sole start condition to **Manual Start**, restricted to the exact **`main` branch**. Do not add branch-change, PR, tag or schedule triggers, or permit arbitrary refs. Inspect the reviewed main commit before starting it. See [start conditions](https://developer.apple.com/documentation/xcode/configuring-start-conditions).
4. Add an iOS **Archive** action using `ProductionApp` / Release, with **TestFlight and App Store** deployment preparation. Use Cloud's automatic signing and follow [Apple's distribution guide](https://developer.apple.com/documentation/xcode/creating-a-workflow-that-builds-your-app-for-distribution). Leave tester-group distribution/post-actions unconfigured until separately reviewed. Uploading a build does not submit an App Store version.
5. Before the first authorized run, confirm that Cloud's build number will not collide with a previously uploaded build.

## Validation boundary

Local builds, tests and an unsigned archive establish compilation/test readiness, not Cloud configuration, signing, authorization or TestFlight delivery. Follow `AGENTS.md` for local checks; verify Cloud results only after a separately authorized run.
