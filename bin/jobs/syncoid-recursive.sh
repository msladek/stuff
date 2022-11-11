#!/bin/bash
currDir="$(dirname "$(readlink -f "$0")")"
$currDir/syncoid-bookmark.sh --recursive --skip-parent $@
