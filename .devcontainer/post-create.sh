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

# wait until dind daemon responds
set -e
echo "Waiting for dind at tcp://dind:2375..."
for i in $(seq 1 30); do
  if curl -s --max-time 1 http://dind:2375/_ping 2>/dev/null | grep -q "OK"; then
    echo "dind is ready"
    docker version || true
    exit 0
  fi
  sleep 1
done
echo "Timeout waiting for dind" >&2
exit 1

# script sh for the start of the 