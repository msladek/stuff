#!/bin/bash
command -v zpool &> /dev/null && hasZFS=true || hasZFS=false
echo -e "\nSetup Jobs ..."
echo "... weekly fstrim"
sudo ln -sf /opt/stuff/scripts/jobs/fstrim.sh /etc/cron.weekly/fstrim
echo "... weekly os-rsync"
backupDir=/mnt/backup
[ ! -d "$backupDir" ] && read -p "Backup dir: " backupDirTo \
  && [ -d "$backupDirTo" ] && sudo ln -s $backupDirTo $backupDir
if [ -d "$backupDir" ]; then
  sudo ln -sf /opt/stuff/scripts/jobs/os-rsync.sh /etc/cron.weekly/os-rsync
else
  echo "skipped, no /mnt/backup linked"
fi
echo "... hourly zfs-health"
if $hasZFS; then
  sudo ln -sf /opt/stuff/scripts/jobs/zfs-health.sh /etc/cron.hourly/zfs-health
  for label in hourly daily weekly monthly; do
    sudo rm -f /etc/cron.${label}/zfs-auto-snapshot
    sudo ln -sf /opt/stuff/scripts/jobs/zfs-auto-snap.sh /etc/cron.${label}/zfs-auto-snap
  done
  sudo ln -sfn /opt/stuff/private/config/$(hostname)/zfs-auto /etc/zfs-auto
  mkdir -p /etc/cron.after
else
  echo "skipped, zfs unavailable"
fi
