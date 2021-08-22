#!/bin/bash

# zfs-auto-snapshot command must be available available
command -v zfs-auto-snapshot &> /dev/null || exit 1

# config directory must exists
cfgdir=/etc/zfs-auto
[[ -d "$cfgdir" ]] || exit 1 

## verify label
label=$(basename $(dirname $0) | cut -d '.' -f2)
validLabel=false
for l in hourly daily weekly monthly; do
  [[ "$l" == "$label" ]] && validLabel=true && break
done
$validLabel || exit 1

# enable debug if set as parameter
for param in "$@"; do
  [[ "$param" == "debug" ]] && debug=true
done

for path in ${cfgdir}/*; do
  snap_dataset=''
  snap_hourly=false
  snap_daily=false
  snap_weekly=false
  snap_monthly=false
  snap_recursive=false
  snap_destroy_only=false
  source $path
  [[ -z "$snap_dataset" ]] \
    && snap_dataset=$(basename $path | sed 's/\\/\//')
  snap_enable=snap_${label}
  snap_enable=${!snap_enable}
  if [[ "$snap_enable" == true || "$snap_enable" -gt 0 ]]; then
    opts="--quiet --syslog"
    [[ "$debug" == true ]] && opts="--dry-run"
    opts="${opts} --prefix=auto --label=${label}"
    [[ "$snap_enable" -gt 0 ]] && opts="${opts} --keep=${snap_enable}"
    [[ "$snap_recursive" == true ]] && opts="${opts} --recursive"
    [[ "$snap_destroy_only" == true ]] && opts="${opts} --destroy-only"
    echo "run: ${opts} "${snap_dataset}""
    zfs-auto-snapshot ${opts} "${snap_dataset}"
  else
    echo "skip: ${label} ${snap_dataset}"
  fi
done

exit 0
