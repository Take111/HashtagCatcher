#!/usr/bin/env python3
"""Fail closed before using signing/upload credentials; never changes GitHub settings."""
import json
import os
from pathlib import Path
import sys
import urllib.request

REPOSITORY = "Take111/HashtagCatcher"
OWNER = "Take111"
BRANCH = "develop"


def check_context(context, event):
    expected = {
        "GITHUB_EVENT_NAME": "workflow_dispatch",
        "GITHUB_REPOSITORY": REPOSITORY,
        "GITHUB_REF": f"refs/heads/{BRANCH}",
        "GITHUB_ACTOR": OWNER,
        "GITHUB_TRIGGERING_ACTOR": OWNER,
    }
    if any(context.get(key) != value for key, value in expected.items()):
        raise ValueError("Only Take111 may dispatch or re-run this workflow on develop.")
    if event.get("repository", {}).get("default_branch") != BRANCH:
        raise ValueError("The default branch changed; review the release policy first.")


def check_environment(environment, policies):
    reviewers = [r for r in environment.get("protection_rules", [])
                 if r.get("type") == "required_reviewers"]
    if len(reviewers) != 1:
        raise ValueError("testflight must require Take111's approval.")
    rule = reviewers[0]
    allowed = rule.get("reviewers", [])
    if (len(allowed) != 1 or allowed[0].get("type") != "User"
            or allowed[0].get("reviewer", {}).get("login") != OWNER):
        raise ValueError("The only required reviewer must be Take111.")
    if rule.get("prevent_self_review") is not False:
        raise ValueError("Owner-only dispatch requires self-review to remain allowed.")
    # The live REST response exposes this even though the OpenAPI schema omits it.
    # Missing/unknown metadata must fail closed.
    if environment.get("can_admins_bypass") is not False:
        raise ValueError("Disable administrator bypass for testflight; unknown state is blocked.")
    if environment.get("deployment_branch_policy") != {
        "protected_branches": False, "custom_branch_policies": True
    }:
        raise ValueError("Use a selected-branch deployment policy for testflight.")
    branches = policies.get("branch_policies", [])
    if (policies.get("total_count") != 1 or len(branches) != 1
            or branches[0].get("name") != BRANCH
            or branches[0].get("type") != "branch"):
        raise ValueError("Allow only the develop branch, with no tags or wildcards.")


def fetch(path):
    request = urllib.request.Request(
        f"https://api.github.com/repos/{REPOSITORY}/{path}",
        headers={"Authorization": f"Bearer {os.environ['GH_TOKEN']}",
                 "Accept": "application/vnd.github+json"},
    )
    with urllib.request.urlopen(request, timeout=30) as response:
        return json.load(response)


def main():
    try:
        check_context(os.environ, json.loads(Path(os.environ["GITHUB_EVENT_PATH"]).read_text()))
        if fetch("").get("default_branch") != BRANCH:
            raise ValueError("The current default branch is no longer develop.")
        check_environment(fetch("environments/testflight"),
                          fetch("environments/testflight/deployment-branch-policies"))
    except Exception as error:
        # Do not dump request headers, credentials, or API response bodies.
        print(f"Release preflight blocked: {type(error).__name__}: {error}", file=sys.stderr)
        return 1
    print("Owner, default branch, and testflight Environment protections verified.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
