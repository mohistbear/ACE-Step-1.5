#!/usr/bin/env bash
# Sync local ACE-Step tree to the 5090 (or other) Linux host via rsync.
# Run this on your Mac / dev machine, not on the server.
#
# Override any default with environment variables, e.g.:
#   REMOTE_HOST=1.2.3.3 ./scripts/sync_to_5090.sh
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

REMOTE_USER="${REMOTE_USER:-work}"
REMOTE_HOST="${REMOTE_HOST:-36.144.20.166}"
REMOTE_DIR="${REMOTE_DIR:-/home/work/code/ACE-Step-1.5}"

RSYNC_DST="${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}/"

echo "============================================"
echo "  ACE-Step → remote rsync"
echo "============================================"
echo "  From: ${PROJECT_ROOT}/"
echo "  To:   ${RSYNC_DST}"
echo "============================================"
echo ""

rsync -avz --progress \
  --exclude ".venv/" \
  --exclude "__pycache__/" \
  --exclude "*.pyc" \
  --exclude ".mypy_cache/" \
  --exclude ".pytest_cache/" \
  --exclude "gradio_outputs/" \
  "${PROJECT_ROOT}/" \
  "${RSYNC_DST}"

echo ""
echo "Done. On the server:"
echo "  ssh ${REMOTE_USER}@${REMOTE_HOST}"
echo "  cd ${REMOTE_DIR} && uv sync && ./scripts/run_acestep_gradio_cuda.sh"
