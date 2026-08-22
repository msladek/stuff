#!/usr/bin/env bash
set -euo pipefail

if (( $# != 1 )); then
  echo "Usage: $(basename "$0") <name>" >&2
  exit 2
fi

codex_dir="$HOME/.codex"
test -d "$codex_dir"
auth_file="$codex_dir/auth.$1.json"
if [[ ! -f "$auth_file" ]]; then
  echo "Error: auth json not found: $auth_file" >&2
  exit 1
fi
ln -sf "$auth_file" "$codex_dir/auth.json"
echo "installed $(basename "$auth_file")"
