#!/bin/bash
backupDir="/mnt/backup/os"
log="/var/log/os-rsync.log"
touch $log

currDate=$(date +"%Y-%m-%d %H:%M")
echo "[${currDate}] / -> ${backupDir}" >> $log
rsync -ax --delete / "$backupDir" &>> $log
