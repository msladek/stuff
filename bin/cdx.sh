#!/usr/bin/env bash
set -euo pipefail

ws_dir=$(realpath "$HOME/ws")
cur_dir=$(pwd -P)

if [[ "$cur_dir" != "$ws_dir" && "$cur_dir" != "$ws_dir"/* ]]; then
    cd "$ws_dir"
fi

exec "$HOME/.npm-global/bin/codex"
