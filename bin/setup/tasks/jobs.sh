#!/bin/bash

echo -e "\nSetup Jobs ..."
[ $EUID -ne 0 ] \
  && echo 'skipped, requires root' \
  && exit 1

jobDir=/opt/msladek/stuff/bin/jobs
etcDir=/opt/msladek/stuffp/etc/$(hostname)

function activate() {
  mask=${3:-644}
  for i in $1; do
    [ -f $i ] \
      && chown root:root $i \
      && chmod $mask $i \
      && ln -sf $i $2
  done
}

echo "... weekly hosts update"
activate $jobDir/hosts-update.sh /etc/cron.weekly/hosts-update 755

echo "... weekly fstrim"
activate $jobDir/fstrim.sh /etc/cron.weekly/fstrim 755

echo "... weekly os-rsync"
[ -d /mnt/backup ] \
  && activate $jobDir/os-rsync.sh /etc/cron.weekly/os-rsync 755 \
  || echo "skipped, no /mnt/backup linked"
if command -v zpool > /dev/null && [ $(zpool list -H | wc -l) -gt 0 ]; then
  echo "... hourly zfs-health"
  activate $jobDir/zfs-health.sh /etc/cron.daily/zfs-health 755
  echo "... sanoid"
  if command -v sanoid > /dev/null; then
    mkdir -p /etc/sanoid
    [ ! -f /etc/sanoid/sanoid.defaults.conf ] \
      && ln -s /usr/share/sanoid/sanoid.defaults.conf /etc/sanoid/sanoid.defaults.conf
    activate $etcDir/sanoid.conf /etc/sanoid/sanoid.conf \
      && systemctl enable --now sanoid.timer
  else
    echo "skipped, sanoid not available"
  fi
  echo "... syncoid"
  command -v syncoid > /dev/null \
    && activate "$etcDir/systemd/syncoid@*" /etc/systemd/system/ \
    && systemctl daemon-reload \
    && for timer in $etcDir/systemd/syncoid@*.timer; do \
         systemctl enable --now $(basename $timer); \
       done \
    || echo "skipped, syncoid not available"
else
  echo "skipped zfs setup, no pools available"
fi
