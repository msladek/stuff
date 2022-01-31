#!/bin/bash
backupDir="/mnt/backup/os"
log="/var/log/os-rsync.log"
touch $log

if [ -w $backupDir ]; then
  currDate=$(date +"%Y-%m-%d %H:%M")
  echo "[${currDate}] / -> ${backupDir}" >> $log
  rsync -ax --delete / "$backupDir" &>> $log
else
  echo "${backupDir} not writable"
  exit 1
fi
