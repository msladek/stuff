#!/bin/bash
echo -e "Subject: [INFO] ZFS scrub started on $(hostname)\n\n`/sbin/zpool status`" | msmtp root@sladek.co
for pool in $(/sbin/zpool list -Ho name); do
  /sbin/zpool scrub $pool
done

