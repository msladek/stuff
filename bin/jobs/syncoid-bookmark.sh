#!/bin/bash
currDir="$(dirname "$(readlink -f "$0")")"
$currDir/syncoid-nonroot.sh --create-bookmark $@
