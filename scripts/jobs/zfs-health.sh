#!/bin/bash
name="zfs-health"
log="/var/log/$name.log"
touch $log

currDate=$(date +"%Y-%m-%d %H:%M")

COND1=$(/sbin/zpool status | egrep -i '(DEGRADED|FAULTED|OFFLINE|UNAVAIL|REMOVED|FAIL|DESTROYED|corrupt|cannot|unrecover)')
COND2=$(/sbin/zpool status | grep ONLINE | grep -v state | awk '{print $3 $4 $5}' | grep -v 000)

echo "[${currDate}] $(hostname) checked: $COND1 $COND2" >> $log
if [ "$COND1$COND2" ]; then
  echo -e "Subject: [IMPORTANT] ZFS fault on $(hostname)\n\n`/sbin/zpool status`" | msmtp root@sladek.co
fi
