#!/usr/bin/env bash
# Start ACE-Step Gradio UI on Linux + NVIDIA CUDA (e.g. RTX 5090).
# Run on the server inside the project root (or from anywhere; script cd's to repo root).
#
# Environment (optional):
#   PORT                 — Gradio port (default 8844)
#   ACESTEP_LM_ENFORCE_EAGER — set to 1 to disable nano-vllm CUDA graphs (5090 auto-handled in code)
#   SKIP_SYNC            — set to 1 to skip "uv sync"
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${PROJECT_ROOT}"

export TOKENIZERS_PARALLELISM="${TOKENIZERS_PARALLELISM:-false}"
export PYTHONUNBUFFERED="${PYTHONUNBUFFERED:-1}"

PORT="${PORT:-8844}"

echo "============================================"
echo "  ACE-Step 1.5 — Linux CUDA (Gradio)"
echo "============================================"
echo "  目录: ${PROJECT_ROOT}"
echo "  端口: ${PORT}"
echo "  绑定: 0.0.0.0"
echo "  LM 后端: vllm (nano-vllm)"
echo "============================================"
echo ""

if [[ -z "${SKIP_SYNC:-}" ]]; then
  echo "[启动] uv sync ..."
  uv sync
else
  echo "[启动] 已跳过 uv sync (SKIP_SYNC=1)"
fi

echo "[启动] 启动 Gradio ..."
exec uv run acestep \
  --port "${PORT}" \
  --server-name 0.0.0.0 \
  --language zh \
  --backend vllm
