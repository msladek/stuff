#!/bin/bash
backupDir="/mnt/backup/os"
log="/var/log/os-rsync.log"
touch $log

if [ -w $backupDir ]; then
  currDate=$(date +"%Y-%m-%d %H:%M")
  echo "[${currDate}] / -> ${backupDir}" | tee -a $log
  rsync -ax --delete --bwlimit=20000 / "$backupDir" | tee -a $log
else
  echo "${backupDir} not writable"
  exit 1
fi
