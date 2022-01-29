#!/bin/bash

echo -e "\nSetup Jobs ..."
[ $EUID -ne 0 ] \
  && echo 'skipped, requires root' \
  && exit 1

etcDir=/opt/stuff/private/etc/$(hostname)
echo "... weekly hosts update"
ln -sf /opt/stuff/bin/jobs/hosts-update.sh /etc/cron.weekly/hosts-update
echo "... weekly fstrim"
ln -sf /opt/stuff/bin/jobs/fstrim.sh /etc/cron.weekly/fstrim
echo "... weekly os-rsync"
backupDir=/mnt/backup
[ ! -d "$backupDir" ] && read -p "Backup dir: " backupDirTo \
  && [ -d "$backupDirTo" ] && ln -s $backupDirTo $backupDir
if [ -d "$backupDir" ]; then
  ln -sf /opt/stuff/bin/jobs/os-rsync.sh /etc/cron.weekly/os-rsync
else
  echo "skipped, no /mnt/backup linked"
fi
if command -v zpool > /dev/null && [ $(zpool list -H | wc -l) -gt 0 ]; then
  echo "... hourly zfs-health"
  ln -sf /opt/stuff/bin/jobs/zfs-health.sh /etc/cron.hourly/zfs-health
  echo "... sanoid"
  if command -v sanoid > /dev/null; then
    mkdir -p /etc/sanoid
    [ ! -f /etc/sanoid/sanoid.defaults.conf ] \
      && ln -s /usr/share/sanoid/sanoid.defaults.conf /etc/sanoid/sanoid.defaults.conf
    ln -sf ${etcDir}/sanoid.conf /etc/sanoid/sanoid.conf
    systemctl enable --now sanoid.timer
  else
    echo "skipped, sanoid not available"
  fi
  echo "... syncoid"
  command -v syncoid > /dev/null \
    && ln -sf ${etcDir}/systemd/syncoid@* /etc/systemd/system/ \
    && systemctl daemon-reload \
    && for timer in ${etcDir}/systemd/syncoid@*.timer; do \
         systemctl enable --now $(basename $timer); \
       done \
    || echo "skipped, syncoid not available"
else
  echo "skipped zfs setup, no pools available"
fi
