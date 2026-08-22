#!/usr/bin/env bash
set -euo pipefail

m2_repo="$HOME/.m2/repository"
m2_max_age_days=120

echo "Pruning Maven artifacts not accessed in $m2_max_age_days days..."
if m2_dataset=$(findmnt --noheadings --types zfs --output SOURCE --target "$m2_repo"); then
  if [[ "$(zfs get -H -o value atime "$m2_dataset")" != "on" ]]; then
    echo "Error: $m2_dataset must have atime=on." >&2
    exit 1
  fi
fi
find "$m2_repo" -type f -name '*.pom' -atime "+$m2_max_age_days" -printf '%h\0' \
  | sort -zu \
  | xargs -0r rm -rfv --
echo "... done"

echo "Verifying and pruning the npm cache..."
npm cache verify
echo "... done"
