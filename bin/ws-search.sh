#!/usr/bin/env bash
set -euo pipefail

ws_dir=$(realpath "$HOME/ws")

if [[ $# -lt 1 ]]; then
  echo "Usage: ws-search <pattern> [grep args...]" >&2
  exit 1
fi

pattern=$1
shift

grep \
  --recursive \
  --binary-files=without-match \
  --line-number \
  --color=auto \
  --exclude-dir={.git,.metadata,node_modules,target,dist,build} \
  "$@" \
  -- "$pattern" "$ws_dir"
