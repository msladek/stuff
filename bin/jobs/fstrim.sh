#!/bin/bash
log="/var/log/fstrim.log"
touch $log
echo "[$(date +"%Y-%m-%d %H:%M")]" >> $log
/sbin/fstrim -av &>> $log
