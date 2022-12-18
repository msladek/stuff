#!/bin/bash
log="/var/log/fstrim.log"
touch $log
echo "[$(date +"%Y-%m-%d %H:%M")]" | tee -a $log
/sbin/fstrim -av | tee -a $log
