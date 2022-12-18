#!/bin/bash

dataset="${1/_/\/}"
[ -z "$dataset" ] && echo 'no dataset provided' && exit 1

keystatus=$(/sbin/zfs get keystatus -H -o value "$dataset")
if [ "${keystatus}" = 'available' ]; then
  echo "ZFS key loaded for ${dataset}"
  exit 0
else
  echo >&2 "ZFS key not loaded for ${dataset}"
  exit 1
fi
