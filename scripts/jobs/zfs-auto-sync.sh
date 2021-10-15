#!/bin/bash

# config directory must exists
cfgdir=/etc/zfs-auto
[[ -d "$cfgdir" ]] || exit 1


########################################################################
# Parse arguments                                                      #
########################################################################

debug=''
while getopts "d" option; do
  case $option in
    d) debug='-d';;
  esac
done

# legacy: enable debug if set as individual parameter
for param in "$@"; do
  [[ "$param" == "debug" ]] && debug='-d'
done


########################################################################
# Main                                                                 #
########################################################################

## TODO locking

for path in ${cfgdir}/*; do
  dataset=''
  sync_target=''
  sync_filter=''
  source $path
  [[ -z "$dataset" ]] && continue
  [[ -z "$sync_target" ]] && continue
  zfsync $debug -f "$sync_filter" "$dataset" "$sync_target"
done
exit 0
