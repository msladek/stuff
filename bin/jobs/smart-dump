#!/bin/bash
smartDir=/mnt/backup/smart
if [ -w $smartDir ]; then
  dateStr=$(date +'%Y-%m-%d-%H%M')
  for device in /dev/disk/by-id/*; do
    [[ -n $device ]] \
      && [[ ! $device =~ -part[0-9]+$ ]] \
      && [[ ! $device =~ ^/dev/disk/by-id/wwn- ]] \
      && [[ ! $device =~ ^/dev/disk/by-id/nvme-nvme ]] \
      && smartctl -i $device &>/dev/null \
      && mkdir -p $smartDir/$dateStr \
      && smartctl -A $device > $smartDir/$dateStr/$(basename $device) \
      && echo "written $smartDir/$dateStr/$(basename $device)"
  done
  exit 0
else
  echo "${smartDir} not writable"
  exit 1
fi
