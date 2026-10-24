# Manual TestFlight upload

This workflow is prepared but **not activated or live-tested**. No `testflight` Environment existed when this change was prepared. Adding its name to YAML does not create protection rules. Signing assets, App Store Connect access and Environment configuration must be supplied by the owner before a first separately authorized upload.

The trusted default branch is `develop` (not `main`). This change builds on PR #19's Xcode 27 toolchain and must reach `develop` after that PR. `Upload to TestFlight` has only `workflow_dispatch`; it never runs for a PR, push or schedule. Both the original actor and re-run actor must be `Take111`, in `Take111/HashtagCatcher`, on `refs/heads/develop`. Checkout uses the event's exact commit, with no ref input. Public PR CI remains secretless on GitHub-hosted runners.

## Owner setup, outside this PR

In repository **Settings → Environments**, create `testflight` and configure:

1. Required reviewers: **Take111 only**. Leave **Prevent self-review** unchecked so this single owner can approve their own manual run.
2. Disable **Allow administrators to bypass configured protection rules**.
3. Deployment branches and tags: **Selected branches and tags**, with exactly one **Branch** rule named `develop`. No wildcard or tag rules.
4. Store the following as **Environment secrets**, never repository/organization secrets or files in Git. Existing credentials must be exported by their authorized owner; the workflow does not create certificates, register devices, or request additional permissions.

| Secret | Required value |
| --- | --- |
| `DISTRIBUTION_P12_BASE64` | Base64 of an existing Apple Distribution `.p12` containing its private key, for the team below |
| `DISTRIBUTION_P12_PASSWORD` | Nonempty password used to protect that `.p12` |
| `APP_STORE_PROFILE_BASE64` | Base64 of an unexpired **App Store Connect distribution** `.mobileprovision` for the Production bundle ID and matching certificate; not development, Ad Hoc or Enterprise |
| `ASC_KEY_ID` | ID of an existing App Store Connect **team API key** authorized to upload this app |
| `ASC_ISSUER_ID` | That key's issuer UUID |
| `ASC_PRIVATE_KEY_P8` | The complete multiline PEM contents of that key's `.p8`, including BEGIN/END lines; not base64 |

Use the least Apple access needed to upload builds. An API key is upload authorization; it does not replace the distribution certificate/private key or provisioning profile. The workflow uses Xcode's existing manual-signing support and does not pass `-allowProvisioningUpdates` or `-allowProvisioningDeviceRegistration`.

Nonsecret identifiers are checked into `ci/testflight-release.sh`, matching `App/Production.xcodeproj/project.pbxproj`: team `DQ6L6A5H88`, bundle `ChikatoTakenouchi.HashtagCatcher`. Xcode is read from `.xcode-version`; the runner is GitHub-hosted `xcode-27`. Review these together if the app's ownership or toolchain changes.

Preflight reads GitHub metadata using the job's read-only token. Missing Environment, reviewer/branch protection, unknown metadata, API failure or a changed default branch blocks the release. It checks again after approval. The live REST response exposes `can_admins_bypass` although its OpenAPI schema currently omits it. The guard requires an explicit `false`; missing/unknown values stop the run, so an API shape change requires review rather than silently weakening protection. The owner must also protect/review changes to `develop` and these workflow files: repository administrators who can change the policy itself are outside this workflow's security boundary. This PR changes no repository settings.

## Later, separately authorized first run

After reviewing/merging the prerequisite changes and configuring the above, confirm ordinary CI is green and test an installed-app upgrade for data retention. Select **Actions → Upload to TestFlight → Run workflow → develop** as Take111. Enter a new build number greater than the last accepted App Store Connect build for the current app version; the workflow accepts Apple's numeric `4.2.2` digit format, for example `2` or `2.1`. The marketing version comes from the Production project, currently `1.3.1`. Before the first upload, verify App Store Connect will accept that version; if it is already released/closed, commit the intended next marketing version first. This PR does not select or publish a new release version. Re-runs retain their original build number; if Apple already accepted it, dispatch a new build number instead.

Approve the `testflight` deployment after checking its commit. The workflow archives Production Release for generic iOS, then exports/uploads using `app-store-connect`. Upload success does not imply Apple processing, export-compliance review, external beta review or test availability has completed. It does not submit an App Store version or manage tester groups; existing App Store Connect automatic distribution settings may apply.

Signing and upload secrets are scoped to their respective steps. A temporary keychain and profile are removed, its previous keychain search list is restored, and the private key/archive/export directory is deleted on completion/failure. An always-run cleanup step is also present; forcibly terminated hosts rely on GitHub-hosted runner disposal. No release files or logs are published as workflow artifacts.

## Validation without uploading

```sh
python3 -m unittest discover -s ci -p 'test_*.py'
bash -n ci/testflight-release.sh
shellcheck ci/testflight-release.sh
actionlint -ignore '^label "xcode-27" is unknown\.' .github/workflows/*.yml
```

The narrow actionlint exception is needed only while the installed validator lacks GitHub's new `xcode-27` label. Run the simulator builds/tests in `AGENTS.md` for ordinary checks. A generic-iOS archive with `CODE_SIGNING_ALLOWED=NO` can validate device compilation, but it cannot verify certificate/profile compatibility or Apple upload authorization. Those remain unverified until the first authorized signed run.

References: [GitHub Environment protection](https://docs.github.com/actions/deployment/targeting-different-environments/using-environments-for-deployment), [Apple build uploads](https://developer.apple.com/help/app-store-connect/manage-builds/upload-builds/). The installed Xcode 27 `xcodebuild -help` documents the manual-signing export keys and API-key arguments used here.
