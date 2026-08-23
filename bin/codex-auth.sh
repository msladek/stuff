#!/usr/bin/env bash
set -euo pipefail

if (( $# != 1 )); then
  echo "Usage: $(basename "$0") <name>" >&2
  exit 2
fi

cd "$HOME/.codex"

auth_file="auth.$1.json"
if [[ ! -f "$auth_file" ]]; then
  echo "Error: auth json not found: $auth_file" >&2
  exit 1
fi
ln -sf "$auth_file" auth.json
echo "installed $auth_file"
