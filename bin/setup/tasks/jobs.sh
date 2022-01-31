#!/bin/bash

echo -e "\nSetup Jobs ..."
[ $EUID -ne 0 ] \
  && echo 'skipped, requires root' \
  && exit 1

jobDir=/opt/msladek/stuff/bin/jobs
etcDir=/opt/msladek/stuff/etc
etcHostDir=/opt/msladek/stuffp/etc/$(hostname)

# make the file immutable by non-roots before symlinking
# set sticky bit on parent dir
function activate() {
  for i in $1; do
    [ -f $i ] \
      && chown root $(dirname $i) && chmod 1775 $(dirname $i) \
      && chown root $i && chmod 644 $i \
      && { [[ $i != *.sh ]] || chmod +x $i; } \
      && ln -sf $i $2
  done
}

function activateTimer() {
  unitDir="${2:-$etcDir}/systemd"
  activate "$unitDir/$1*.{service,timer}" /etc/systemd/system/ \
    && systemctl daemon-reload \
    && for timer in $unitDir/$1*.timer; do \
        systemctl enable --now $(basename $timer); \
       done
}

echo "... weekly hosts update"
activate $jobDir/hosts-update.sh /etc/cron.weekly/hosts-update

echo "... weekly fstrim"
activate $jobDir/fstrim.sh /etc/cron.weekly/fstrim

echo "... weekly os-rsync"
[ -w /mnt/backup/os ] \
  && activate $jobDir/os-rsync.sh /etc/cron.weekly/os-rsync \
  || echo "skipped, no /mnt/backup/os linked"

echo "... daily smart-dump"
[ -w /mnt/backup/smart ] \
  && activateTimer 'smart-dump' \
  || echo "skipped, no /mnt/backup/smart linked"

if command -v zpool > /dev/null && [ $(zpool list -H | wc -l) -gt 0 ]; then
  echo "... hourly zfs-health"
  activate $jobDir/zfs-health.sh /etc/cron.hourly/zfs-health

  echo "... sanoid"
  if command -v sanoid > /dev/null; then
    mkdir -p /etc/sanoid
    [ ! -f /etc/sanoid/sanoid.defaults.conf ] \
      && ln -s /usr/share/sanoid/sanoid.defaults.conf /etc/sanoid/sanoid.defaults.conf
    activate $etcHostDir/sanoid.conf /etc/sanoid/sanoid.conf \
      && systemctl enable --now sanoid.timer
  else
    echo "skipped, sanoid not available"
  fi

  echo "... syncoid"
  command -v syncoid > /dev/null \
    && activateTimer 'syncoid' "$etcHostDir" \
    || echo "skipped, syncoid not available"

else
  echo "skipped zfs setup, no pools available"
fi
