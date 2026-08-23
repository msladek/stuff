#!/usr/bin/env bash
set -euo pipefail

if (( $# != 1 )); then
  echo "Usage: $(basename "$0") user@host" >&2
  exit 2
fi

exec tmux new-window -n "$1" -- herdr --remote "$1"
