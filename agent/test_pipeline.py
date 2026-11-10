"""
Unit tests for the agent pipeline.

Runs in three tiers:
  1. Validation-only tests  — no QEMU needed.
  2. Mocked bridge tests     — no QEMU needed; bridge is replaced by a stub.
  3. Live QEMU round-trip    — requires a built xv6 image and QEMU.

Run all:   python3 -m unittest agent.test_pipeline -v
Skip live: python3 -m unittest agent.test_pipeline.ValidationTests agent.test_pipeline.MockedBridgeTests -v
"""

import json
import unittest
from unittest.mock import MagicMock, patch


# ---------------------------------------------------------------------------
# Tier 1: validate_action — no QEMU, no imports beyond the bridge module
# ---------------------------------------------------------------------------

class ValidationTests(unittest.TestCase):
    """Tests for bridge.validate_action() — pure logic, no QEMU."""

    def setUp(self):
        from agent.bridge import validate_action
        self.validate = validate_action

    # --- known tools --------------------------------------------------------

    def test_list_files_valid(self):
        self.assertEqual(self.validate("list_files", {"path": "/"}), "/")

    def test_read_file_valid(self):
        self.assertEqual(self.validate("read_file", {"path": "/report.txt"}), "/report.txt")

    def test_mark_file_valid(self):
        self.assertEqual(self.validate("mark_file", {"path": "/inbox.txt"}), "/inbox.txt")

    def test_try_write_valid(self):
        self.assertEqual(self.validate("try_write", {"path": "/clean.txt"}), "/clean.txt")

    def test_taint_status_no_args(self):
        self.assertIsNone(self.validate("taint_status", {}))

    # --- unknown tool -------------------------------------------------------

    def test_unknown_tool(self):
        with self.assertRaises(ValueError):
            self.validate("delete_file", {"path": "/"})

    # --- path validation ----------------------------------------------------

    def test_relative_path_rejected(self):
        with self.assertRaises(ValueError):
            self.validate("read_file", {"path": "report.txt"})

    def test_dotdot_rejected(self):
        with self.assertRaises(ValueError):
            self.validate("read_file", {"path": "/../etc/passwd"})

    def test_dot_component_rejected(self):
        with self.assertRaises(ValueError):
            self.validate("read_file", {"path": "/./report.txt"})

    def test_long_component_rejected(self):
        with self.assertRaises(ValueError):
            self.validate("read_file", {"path": "/a" + "b" * 14})

    def test_missing_path_arg(self):
        with self.assertRaises(ValueError):
            self.validate("read_file", {})

    def test_extra_arg_rejected(self):
        with self.assertRaises(ValueError):
            self.validate("read_file", {"path": "/a.txt", "extra": "x"})

    def test_taint_status_with_path_rejected(self):
        with self.assertRaises(ValueError):
            self.validate("taint_status", {"path": "/inbox.txt"})

    def test_path_with_safe_subdir(self):
        self.assertEqual(self.validate("read_file", {"path": "/safe/taint_probe"}), "/safe/taint_probe")


# ---------------------------------------------------------------------------
# Tier 2: Mocked bridge — exercises main.py logic without QEMU
# ---------------------------------------------------------------------------

class MockedBridgeTests(unittest.TestCase):
    """Tests for execute_tool() and scripted_action() using a stub bridge."""

    def _make_bridge(self, return_value):
        bridge = MagicMock()
        bridge.execute.return_value = return_value
        return bridge

    def test_execute_tool_success(self):
        from agent.main import execute_tool
        bridge = self._make_bridge({"ok": True, "path": "/report.txt", "content": "hello", "truncated": False})
        result = execute_tool(bridge, "read_file", {"path": "/report.txt"})
        self.assertTrue(result["ok"])
        self.assertEqual(result["content"], "hello")

    def test_execute_tool_validation_error(self):
        from agent.main import execute_tool
        bridge = MagicMock()
        bridge.execute.side_effect = ValueError("Unknown tool 'unknown_tool'.")
        result = execute_tool(bridge, "unknown_tool", {"path": "/"})
        self.assertFalse(result["ok"])
        self.assertIn("error", result)

    def test_scripted_list_root(self):
        from agent.main import scripted_action
        self.assertEqual(scripted_action("list"), ("list_files", {"path": "/"}))

    def test_scripted_list_path(self):
        from agent.main import scripted_action
        self.assertEqual(scripted_action("list /"), ("list_files", {"path": "/"}))

    def test_scripted_read(self):
        from agent.main import scripted_action
        self.assertEqual(scripted_action("read /report.txt"), ("read_file", {"path": "/report.txt"}))

    def test_scripted_taint(self):
        from agent.main import scripted_action
        self.assertEqual(scripted_action("taint /inbox.txt"), ("mark_file", {"path": "/inbox.txt"}))

    def test_scripted_write(self):
        from agent.main import scripted_action
        self.assertEqual(scripted_action("write /clean.txt"), ("try_write", {"path": "/clean.txt"}))

    def test_scripted_status(self):
        from agent.main import scripted_action
        self.assertEqual(scripted_action("status"), ("taint_status", {}))

    def test_scripted_invalid(self):
        from agent.main import scripted_action
        with self.assertRaises(ValueError):
            scripted_action("delete /foo")

    def test_taint_demo_sequence(self):
        """run_taint_demo issues exactly 5 execute calls in the right order."""
        from agent.main import run_taint_demo
        bridge = MagicMock()
        bridge.execute.side_effect = [
            {"ok": True, "path": "/inbox.txt"},                             # mark_file
            {"ok": True, "path": "/inbox.txt", "content": "secret", "truncated": False},  # read_file
            {"ok": True, "tainted": True},                                  # taint_status
            {"ok": False, "path": "/clean.txt", "error": "write_blocked"},  # try_write
            {"ok": True, "path": "/clean.txt", "content": "clean", "truncated": False},   # read_file
        ]
        run_taint_demo(bridge)
        self.assertEqual(bridge.execute.call_count, 5)
        calls = bridge.execute.call_args_list
        self.assertEqual(calls[0][0][0], "mark_file")
        self.assertEqual(calls[1][0][0], "read_file")
        self.assertEqual(calls[2][0][0], "taint_status")
        self.assertEqual(calls[3][0][0], "try_write")
        self.assertEqual(calls[4][0][0], "read_file")


# ---------------------------------------------------------------------------
# Tier 3: Live QEMU round-trip (skipped if xv6 images are not built)
# ---------------------------------------------------------------------------

import os as _os
import shutil as _shutil

_IMAGES_PRESENT = (
    _os.path.exists("/home/primz/Downloads/xv6-public/xv6.img") and
    _os.path.exists("/home/primz/Downloads/xv6-public/agent-fs.img") and
    _shutil.which("qemu-system-i386") is not None or
    _shutil.which("qemu-system-x86_64") is not None
)


@unittest.skipUnless(_IMAGES_PRESENT, "xv6 disk images or QEMU not available; skipping live tests")
class LiveQemuTests(unittest.TestCase):
    """Real round-trip tests through QEMU.  Each test gets a fresh QEMU boot."""

    @classmethod
    def setUpClass(cls):
        from agent.bridge import QemuBridge
        cls.bridge = QemuBridge()
        cls.bridge.start()

    @classmethod
    def tearDownClass(cls):
        cls.bridge.close()

    def test_list_root(self):
        result = self.bridge.execute("list_files", {"path": "/"})
        self.assertTrue(result["ok"])
        self.assertIn("report.txt", result["content"])

    def test_read_report(self):
        result = self.bridge.execute("read_file", {"path": "/report.txt"})
        self.assertTrue(result["ok"])
        self.assertIsInstance(result["content"], str)
        self.assertGreater(len(result["content"]), 0)

    def test_read_missing_file(self):
        result = self.bridge.execute("read_file", {"path": "/missing.txt"})
        self.assertFalse(result["ok"])
        self.assertEqual(result["error"], "open_failed")

    def test_taint_status_initially_clean(self):
        result = self.bridge.execute("taint_status", {})
        self.assertTrue(result["ok"])
        self.assertFalse(result["tainted"])

    def test_mark_and_read_taints_worker(self):
        self.bridge.execute("mark_file", {"path": "/inbox.txt"})
        self.bridge.execute("read_file", {"path": "/inbox.txt"})
        result = self.bridge.execute("taint_status", {})
        self.assertTrue(result["ok"])
        self.assertTrue(result["tainted"])

    def test_write_blocked_after_taint(self):
        # Worker is already tainted from the previous test (same QEMU session).
        result = self.bridge.execute("try_write", {"path": "/clean.txt"})
        self.assertFalse(result["ok"])
        self.assertEqual(result["error"], "write_blocked")


if __name__ == "__main__":
    unittest.main()

