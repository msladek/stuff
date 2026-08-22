#!/usr/bin/env bash
set -euo pipefail

if (($# == 0)); then
  echo "Usage: $(basename "$0") <module> [...]" >&2
  exit 2
fi

for module in "$@"; do
  pom="$HOME/ws/$module/pom.xml"
  if [[ ! -f "$pom" ]]; then
    echo "Error: Maven project not found: $pom" >&2
    exit 1
  fi
  echo "==> Building $module"
  mvn clean install -f "$pom" -Dmaven.test.skip=true -q
done
