#!/bin/bash
command -v zpool &> /dev/null && hasZFS=true || hasZFS=false
echo -e "\nSetup Jobs ..."
echo "... weekly fstrim"
sudo ln -s ~/stuff/scripts/jobs/fstrim.sh /etc/cron.weekly/fstrim
echo "... weekly os-rsync"
backupDir=/mnt/backup
[ ! -d "$backupDir" ] && read -p "Backup dir: " backupDirTo \
  && [ -d "$backupDirTo" ] && sudo ln -s $backupDirTo $backupDir
if [ -d "$backupDir" ]; then
  sudo ln -s ~/stuff/scripts/jobs/os-rsync.sh /etc/cron.weekly/os-rsync
else
  echo "skipped, no /mnt/backup linked"
fi
echo "... hourly zfs-health"
if $hasZFS; then
  sudo ln -s ~/stuff/scripts/jobs/zfs-health.sh /etc/cron.hourly/zfs-health
else
  echo "skipped, zfs unavailable"
fi
