import unittest
from agent import after_job, validate


class ValidateTest(unittest.TestCase):
    def test_allows_only_five_actions(self):
        self.assertEqual(validate({"action": "env-up"}), ["env-up"])
        self.assertIsNone(validate({"action": "rm"}))
        self.assertIsNone(validate("env-up"))

    def test_lab_actions_need_a_safe_lab_id(self):
        self.assertEqual(validate({"action": "lab-setup", "lab": "mock-04-controlplane-failure"}), ["lab-setup", "mock-04-controlplane-failure"])
        self.assertIsNone(validate({"action": "lab-setup", "lab": "../../etc/passwd"}))
        self.assertIsNone(validate({"action": "lab-setup", "lab": "labs-05-x; rm -rf ~"}))
        self.assertIsNone(validate({"action": "lab-cleanup"}))


class AfterJobTest(unittest.TestCase):
    """작업 뒤 보고할 (env, activeLab, 이어서 할 동작). env는 lab.sh status로 확인한 실제 값을 쓴다."""

    def test_uses_the_real_env_state(self):
        self.assertEqual(after_job(["env-up"], False, "off"), ("off", None, None))
        self.assertEqual(after_job(["env-down"], False, "ready"), ("ready", None, None))
        self.assertEqual(after_job(["env-down"], True, "off"), ("off", None, None))

    def test_setup_marks_the_lab_active_even_when_it_fails(self):
        self.assertEqual(after_job(["lab-setup", "labs-09-networkpolicy"], True, "ready"), ("ready", "labs-09-networkpolicy", None))
        self.assertEqual(after_job(["lab-setup", "labs-09-networkpolicy"], False, "ready"), ("ready", "labs-09-networkpolicy", None))

    def test_failed_cleanup_resets_the_cluster(self):
        self.assertEqual(after_job(["lab-cleanup", "mock-05-kubelet-failure"], False, "ready"), ("ready", "mock-05-kubelet-failure", "env-reset"))
        self.assertEqual(after_job(["lab-cleanup", "labs-09-networkpolicy"], True, "ready"), ("ready", None, None))

    def test_reset_clears_the_active_lab(self):
        self.assertEqual(after_job(["env-reset"], True, "ready"), ("ready", None, None))


if __name__ == "__main__":
    unittest.main()
