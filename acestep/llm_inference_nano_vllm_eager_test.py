"""Tests for nano-vllm enforce_eager overrides on CUDA."""

import os
import unittest
from unittest import mock

from acestep.llm_inference import _nano_vllm_enforce_eager_cuda_override


class TestNanoVllmEnforceEagerCudaOverride(unittest.TestCase):
    def test_env_forces_eager_without_cuda(self):
        with mock.patch.dict("os.environ", {"ACESTEP_LM_ENFORCE_EAGER": "1"}, clear=False):
            on, reason = _nano_vllm_enforce_eager_cuda_override()
        self.assertTrue(on)
        self.assertEqual(reason, "ACESTEP_LM_ENFORCE_EAGER")

    def test_rtx_5090_name_forces_eager_when_cuda_available(self):
        with mock.patch("torch.cuda.is_available", return_value=True), mock.patch(
            "torch.cuda.get_device_name", return_value="NVIDIA GeForce RTX 5090"
        ):
            on, reason = _nano_vllm_enforce_eager_cuda_override()
        self.assertTrue(on)
        self.assertIn("5090", reason.lower())

    def test_non_blackwell_no_env_returns_false(self):
        with mock.patch.dict(os.environ, {"ACESTEP_LM_ENFORCE_EAGER": ""}, clear=False), mock.patch(
            "torch.cuda.is_available", return_value=True
        ), mock.patch(
            "torch.cuda.get_device_name", return_value="NVIDIA GeForce RTX 4090"
        ):
            on, reason = _nano_vllm_enforce_eager_cuda_override()
        self.assertFalse(on)
        self.assertEqual(reason, "")


if __name__ == "__main__":
    unittest.main()
