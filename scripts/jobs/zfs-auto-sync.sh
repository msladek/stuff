#!/bin/bash

# config directory must exists
cfgdir=/etc/zfs-auto
[[ -d "$cfgdir" ]] || exit 1

# zfsync must be available
command -v zfsync >/dev/null || exit 1

# prepare log
log="/var/log/zfs-auto-sync.log"
touch $log


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

(
  flock --exclusive --nonblock 99 || exit 1
  for path in ${cfgdir}/*; do
    dataset=''
    sync_target=''
    sync_filter=''
    source $path
    [[ -z "$dataset" ]] && continue
    [[ -z "$sync_target" ]] && continue
    zfsync $debug -f "$sync_filter" "$dataset" "$sync_target" &>> $log
  done
  exit 0
) 99>/var/lock/zfs-auto-sync
exit $?
