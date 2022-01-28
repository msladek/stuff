#!/bin/bash
echo -e "\nSetup Jobs ..."
etcDir=/opt/stuff/private/etc/$(hostname)
echo "... weekly hosts update"
sudo ln -sf /opt/stuff/scripts/jobs/hosts-update.sh /etc/cron.weekly/hosts-update
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
if command -v zpool > /dev/null && [ $(zpool list -H | wc -l) -gt 0 ]; then
  echo "... hourly zfs-health"
  sudo ln -sf /opt/stuff/scripts/jobs/zfs-health.sh /etc/cron.hourly/zfs-health
  echo "... sanoid"
  if command -v sanoid > /dev/null; then
    sudo mkdir -p /etc/sanoid
    [ ! -f /etc/sanoid/sanoid.defaults.conf ] \
      && sudo ln -s /usr/share/sanoid/sanoid.defaults.conf /etc/sanoid/sanoid.defaults.conf
    sudo ln -sf ${etcDir}/sanoid.conf /etc/sanoid/sanoid.conf
    sudo systemctl enable --now sanoid.timer
  else
    echo "skipped, sanoid not available"
  fi
  echo "... syncoid"
  command -v syncoid > /dev/null \
    && sudo ln -sf ${etcDir}/systemd/syncoid@* /etc/systemd/system/ \
    && sudo systemctl daemon-reload \
    && for timer in ${etcDir}/systemd/syncoid@*.timer; do \
         sudo systemctl enable --now $(basename $timer); \
       done \
    || echo "skipped, syncoid not available"
else
  echo "skipped zfs setup, no pools available"
fi