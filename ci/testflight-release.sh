#!/bin/bash
# This script is invoked only by the protected manual workflow. Never enable xtrace.
set -euo pipefail
umask 077

# Public identifiers already used by the Production Xcode project.
TEAM_ID=DQ6L6A5H88
BUNDLE_ID=ChikatoTakenouchi.HashtagCatcher
: "${RUNNER_TEMP:?Run this only on the ephemeral GitHub-hosted runner}"
RELEASE_DIR="$RUNNER_TEMP/hashtag-testflight"
KEYCHAIN="$RELEASE_DIR/signing.keychain-db"

cleanup() {
  if [[ -f "$RELEASE_DIR/keychains.json" ]]; then
    python3 - "$RELEASE_DIR/keychains.json" <<'PY' || true
import json, subprocess, sys
subprocess.run(['security', 'list-keychains', '-d', 'user', '-s',
                *json.load(open(sys.argv[1]))], check=True)
PY
  fi
  security delete-keychain "$KEYCHAIN" 2>/dev/null || true
  if [[ -f "$RELEASE_DIR/profile-path" ]]; then
    local profile
    profile=$(cat "$RELEASE_DIR/profile-path")
    case "$profile" in
      "$HOME/Library/Developer/Xcode/UserData/Provisioning Profiles/"*.mobileprovision)
        rm -f "$profile" ;;
    esac
  fi
  rm -rf "$RELEASE_DIR"
}

finish_upload() {
  local release_status=$?
  cleanup
  exit "$release_status"
}

case "${1:-}" in
  archive)
    : "${DISTRIBUTION_P12_BASE64:?Missing distribution certificate}"
    : "${DISTRIBUTION_P12_PASSWORD:?Missing certificate password}"
    : "${APP_STORE_PROFILE_BASE64:?Missing App Store provisioning profile}"
    [[ "${BUILD_NUMBER:-}" =~ ^[1-9][0-9]{0,3}(\.[0-9]{1,2}){0,2}$ ]] || {
      echo 'Invalid build number: use up to 4.2.2 numeric digits.' >&2; exit 1;
    }
    mkdir "$RELEASE_DIR"
    archive_succeeded=false
    trap 'if [[ "$archive_succeeded" != true ]]; then cleanup; fi' EXIT
    trap 'exit 1' INT TERM
    printf '%s' "$DISTRIBUTION_P12_BASE64" | base64 --decode > "$RELEASE_DIR/certificate.p12"
    printf '%s' "$APP_STORE_PROFILE_BASE64" | base64 --decode > "$RELEASE_DIR/profile.mobileprovision"
    security cms -D -i "$RELEASE_DIR/profile.mobileprovision" > "$RELEASE_DIR/profile.plist"
    # Validate identity, expiry and distribution type without logging the profile.
    python3 - "$RELEASE_DIR" "$TEAM_ID" "$BUNDLE_ID" <<'PY'
from datetime import datetime, timezone
from pathlib import Path
import plistlib, re, sys
root, team, bundle = Path(sys.argv[1]), sys.argv[2], sys.argv[3]
p = plistlib.loads((root / 'profile.plist').read_bytes())
e = p['Entitlements']
assert p['TeamIdentifier'] == [team], 'Wrong profile team'
assert e['application-identifier'] == f'{team}.{bundle}', 'Wrong profile app'
assert e.get('get-task-allow') is False, 'A distribution profile is required'
assert 'ProvisionedDevices' not in p and not p.get('ProvisionsAllDevices'), 'Use an App Store profile'
assert p['ExpirationDate'].replace(tzinfo=timezone.utc) > datetime.now(timezone.utc), 'Expired profile'
assert re.fullmatch(r'[0-9A-Fa-f-]{36}', p['UUID']), 'Invalid profile UUID'
(root / 'profile-uuid').write_text(p['UUID'])
options = {'method': 'app-store-connect', 'destination': 'upload', 'teamID': team,
           'signingStyle': 'manual', 'signingCertificate': 'Apple Distribution',
           'provisioningProfiles': {bundle: p['UUID']},
           'manageAppVersionAndBuildNumber': False, 'uploadSymbols': True}
(root / 'ExportOptions.plist').write_bytes(plistlib.dumps(options))
PY
    PROFILE_UUID=$(cat "$RELEASE_DIR/profile-uuid")
    PROFILE_DIR="$HOME/Library/Developer/Xcode/UserData/Provisioning Profiles"
    mkdir -p "$PROFILE_DIR"
    PROFILE_PATH="$PROFILE_DIR/$PROFILE_UUID.mobileprovision"
    [[ ! -e "$PROFILE_PATH" ]] || { echo 'Profile already exists; refusing to overwrite it.' >&2; exit 1; }
    printf '%s' "$PROFILE_PATH" > "$RELEASE_DIR/profile-path"
    cp "$RELEASE_DIR/profile.mobileprovision" "$PROFILE_PATH"
    KEYCHAIN_PASSWORD=$(openssl rand -hex 32)
    security create-keychain -p "$KEYCHAIN_PASSWORD" "$KEYCHAIN"
    security set-keychain-settings -lut 3600 "$KEYCHAIN"
    security unlock-keychain -p "$KEYCHAIN_PASSWORD" "$KEYCHAIN"
    security import "$RELEASE_DIR/certificate.p12" -k "$KEYCHAIN" \
      -P "$DISTRIBUTION_P12_PASSWORD" -T /usr/bin/codesign -T /usr/bin/security >/dev/null
    security set-key-partition-list -S apple-tool:,apple:,codesign: -s \
      -k "$KEYCHAIN_PASSWORD" "$KEYCHAIN" >/dev/null
    python3 - "$RELEASE_DIR/keychains.json" "$KEYCHAIN" <<'PY'
import json, shlex, subprocess, sys
existing = shlex.split(subprocess.check_output(['security', 'list-keychains', '-d', 'user'], text=True))
with open(sys.argv[1], 'w') as f:
    json.dump(existing, f)
subprocess.run(['security', 'list-keychains', '-d', 'user', '-s', sys.argv[2], *existing], check=True)
PY
    unset DISTRIBUTION_P12_BASE64 DISTRIBUTION_P12_PASSWORD APP_STORE_PROFILE_BASE64 KEYCHAIN_PASSWORD
    xcodebuild -workspace HashtagCatcher.xcworkspace -scheme ProductionApp \
      -configuration Release -destination 'generic/platform=iOS' \
      -archivePath "$RELEASE_DIR/HashtagCatcher.xcarchive" \
      -derivedDataPath .build/ReleaseDerivedData -clonedSourcePackagesDirPath .build/SourcePackages \
      -disableAutomaticPackageResolution DEVELOPMENT_TEAM="$TEAM_ID" CODE_SIGN_STYLE=Manual \
      CODE_SIGN_IDENTITY='Apple Distribution' PROVISIONING_PROFILE_SPECIFIER="$PROFILE_UUID" \
      CURRENT_PROJECT_VERSION="$BUILD_NUMBER" archive
    archive_succeeded=true
    ;;
  upload)
    trap finish_upload EXIT
    trap 'exit 1' INT TERM
    : "${ASC_KEY_ID:?Missing App Store Connect key ID}"
    : "${ASC_ISSUER_ID:?Missing App Store Connect issuer ID}"
    : "${ASC_PRIVATE_KEY_P8:?Missing App Store Connect private key}"
    [[ -d "$RELEASE_DIR/HashtagCatcher.xcarchive" ]] || exit 1
    printf '%s\n' "$ASC_PRIVATE_KEY_P8" > "$RELEASE_DIR/AuthKey.p8"
    unset ASC_PRIVATE_KEY_P8
    xcodebuild -exportArchive -archivePath "$RELEASE_DIR/HashtagCatcher.xcarchive" \
      -exportOptionsPlist "$RELEASE_DIR/ExportOptions.plist" \
      -exportPath "$RELEASE_DIR/export" -authenticationKeyPath "$RELEASE_DIR/AuthKey.p8" \
      -authenticationKeyID "$ASC_KEY_ID" -authenticationKeyIssuerID "$ASC_ISSUER_ID"
    ;;
  cleanup) cleanup ;;
  *) echo 'Usage: testflight-release.sh archive|upload|cleanup' >&2; exit 1 ;;
esac
