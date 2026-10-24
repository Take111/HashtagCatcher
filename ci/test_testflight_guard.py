"""Negative tests for the release authorization boundary; no network or secrets."""
import copy
import importlib.util
from pathlib import Path
import unittest

spec = importlib.util.spec_from_file_location("guard", Path(__file__).with_name("testflight-guard.py"))
guard = importlib.util.module_from_spec(spec)
spec.loader.exec_module(guard)


class ReleaseGuardTests(unittest.TestCase):
    def setUp(self):
        self.context = {
            "GITHUB_EVENT_NAME": "workflow_dispatch",
            "GITHUB_REPOSITORY": "Take111/HashtagCatcher",
            "GITHUB_REF": "refs/heads/develop",
            "GITHUB_ACTOR": "Take111",
            "GITHUB_TRIGGERING_ACTOR": "Take111",
        }
        self.event = {"repository": {"default_branch": "develop"}}
        self.environment = {
            "can_admins_bypass": False,
            "protection_rules": [{"type": "required_reviewers", "prevent_self_review": False,
                                  "reviewers": [{"type": "User", "reviewer": {"login": "Take111"}}]}],
            "deployment_branch_policy": {"protected_branches": False, "custom_branch_policies": True},
        }
        self.policies = {"total_count": 1, "branch_policies": [{"type": "branch", "name": "develop"}]}

    def test_owner_dispatch_with_protected_environment_is_allowed(self):
        guard.check_context(self.context, self.event)
        guard.check_environment(self.environment, self.policies)

    def test_each_wrong_context_is_denied(self):
        for key, wrong in {
            "GITHUB_EVENT_NAME": "pull_request", "GITHUB_REPOSITORY": "someone/HashtagCatcher",
            "GITHUB_REF": "refs/heads/feature", "GITHUB_ACTOR": "someone",
            "GITHUB_TRIGGERING_ACTOR": "someone",
        }.items():
            with self.subTest(key=key), self.assertRaises(ValueError):
                guard.check_context({**self.context, key: wrong}, self.event)

    def test_tag_named_develop_is_denied(self):
        with self.assertRaises(ValueError):
            guard.check_context({**self.context, "GITHUB_REF": "refs/tags/develop"}, self.event)

    def test_changed_default_branch_is_denied(self):
        with self.assertRaises(ValueError):
            guard.check_context(self.context, {"repository": {"default_branch": "main"}})

    def test_empty_environment_is_denied(self):
        with self.assertRaises(ValueError):
            guard.check_environment({}, {})

    def test_missing_protections_are_denied(self):
        for replacement in [
            {"can_admins_bypass": True}, {"can_admins_bypass": None},
            {"protection_rules": []}, {"deployment_branch_policy": None},
        ]:
            with self.subTest(replacement=replacement), self.assertRaises(ValueError):
                guard.check_environment({**self.environment, **replacement}, self.policies)

    def test_extra_reviewer_is_denied(self):
        e = copy.deepcopy(self.environment)
        e["protection_rules"][0]["reviewers"].append({"type": "User", "reviewer": {"login": "someone"}})
        with self.assertRaises(ValueError):
            guard.check_environment(e, self.policies)

    def test_self_review_deadlock_is_denied(self):
        e = copy.deepcopy(self.environment)
        e["protection_rules"][0]["prevent_self_review"] = True
        with self.assertRaises(ValueError):
            guard.check_environment(e, self.policies)

    def test_wildcard_tag_extra_and_missing_branch_rules_are_denied(self):
        for policies in [
            {"total_count": 1, "branch_policies": [{"type": "branch", "name": "*"}]},
            {"total_count": 1, "branch_policies": [{"type": "tag", "name": "develop"}]},
            {"total_count": 2, "branch_policies": self.policies["branch_policies"]},
            {"total_count": 0, "branch_policies": []},
        ]:
            with self.subTest(policies=policies), self.assertRaises(ValueError):
                guard.check_environment(self.environment, policies)


if __name__ == "__main__":
    unittest.main()
