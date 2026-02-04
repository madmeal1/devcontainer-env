#!/usr/bin/env bash
set -euo pipefail

echo "Running post-create tasks..."

PYTHON=python3
VENV_DIR="/home/dev/.venv"

if command -v $PYTHON >/dev/null 2>&1; then
  echo "Creating venv at $VENV_DIR"
  $PYTHON -m venv "$VENV_DIR" || true
  "$VENV_DIR/bin/pip" install --upgrade pip setuptools wheel || true
else
  echo "python3 not found, skipping venv creation"
fi

echo "Post-create done"
