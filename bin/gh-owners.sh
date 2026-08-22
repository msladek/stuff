#!/usr/bin/env bash
set -euo pipefail
shopt -s nullglob

token_dir="${XDG_CONFIG_HOME:-$HOME/.config}/gh/tokens"

for token_file in "$token_dir"/*; do
  [[ -f "$token_file" && ! -L "$token_file" && -r "$token_file" ]] || continue
  owner="$(basename "$token_file")"
  [[ "$owner" == "public" ]] && continue
  printf '%s\n' "$owner"
done | sort
