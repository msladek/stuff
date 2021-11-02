#!/bin/bash

cfgdir=/etc/zfs-auto
[[ ! -d "$cfgdir" ]] && "[ERROR] /etc/zfs-auto must exist" && exit 1

# zfsync must be available
command -v zfsync >/dev/null || exit 1

# prepare log
logger="/var/log/zfs-auto-sync.log"
touch $logger
log() {
  while read line; do
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] ${line}" | tee -a $logger
  done
}


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
    zfsync $debug -f "$sync_filter" "$dataset" "$sync_target" | log
  done
  exit 0
) 99>/var/lock/zfs-auto-sync
exit $?
