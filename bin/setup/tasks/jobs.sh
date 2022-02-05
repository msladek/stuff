#!/bin/bash

echo -e "\nSetup Jobs ..."
[ $EUID -ne 0 ] \
  && echo 'skipped, requires root' \
  && exit 1

unitDir=/opt/msladek/stuff/etc/systemd
etcHostDir=/opt/msladek/stuffp/etc/$(hostname)

# make the file immutable by other users, sets sticky bit on parent dir
function claim() {
  [ ! -z $1 ] && [ -f $1 ] \
    && chown $USER $(dirname $1) && chmod 1775 $(dirname $1) \
    && chown $USER $1 && chmod 644 $1 \
    && { [[ $1 != *.sh ]] || chmod +x $1; }
}

function activate() {
  for i in $1; do
    [[ $i =~ \.service$ ]] \
      && script=$(grep "^ExecStart=.*\.sh" $i | cut -c11-) \
      && claim $script
    claim $i && ln -sf $i $2
  done
}

function activateTimer() {
  [ -d "$(dirname $1)" ] \
    && activate "${1}*.service" /etc/systemd/system/ \
    && activate "${1}*.timer" /etc/systemd/system/ \
    && systemctl daemon-reload \
    && for timer in ${1}*.timer; do \
        systemctl enable $(basename $timer); \
       done \
    && echo "done" || { echo "failed" && false; }
}

claim $unitDir/notify-failure

echo "... hosts file update"
activateTimer $unitDir/hosts-update \
  && rm -f /etc/cron.weekly/hosts-update

echo "... filesytem trim"
activateTimer $unitDir/fstrim \
  && rm -f /etc/cron.weekly/fstrim

echo "... OS sync"
if [ -w /mnt/backup/os ]; then
  activateTimer $unitDir/os-rsync \
    && rm -f /etc/cron.weekly/os-rsync
else
  echo "skipped, /mnt/backup/os not linked"
fi

echo "... smart attribute dump"
if [ -w /mnt/backup/smart ]; then
  activateTimer $unitDir/smart-dump
else
  echo "skipped, /mnt/backup/smart not linked"
fi

echo "... database dump"
if [ -w /mnt/backup/mysql ]; then
  activateTimer $unitDir/mysql-dump
else
  echo "skipped, /mnt/backup/mysql not linked"
fi

if ! command -v zpool > /dev/null || [ $(zpool list -H | wc -l) -eq 0 ]; then
  echo "skipped zfs setup, no pools available"
else
  echo "... zfs health check"
  activateTimer $unitDir/zfs-health \
    && rm -f /etc/cron.hourly/zfs-health

  echo "... sanoid"
  if command -v sanoid > /dev/null; then
    mkdir -p /etc/sanoid
    [ ! -f /etc/sanoid/sanoid.defaults.conf ] \
      && ln -s /usr/share/sanoid/sanoid.defaults.conf /etc/sanoid/sanoid.defaults.conf
    activate $etcHostDir/sanoid.conf /etc/sanoid/sanoid.conf \
      && systemctl enable sanoid.timer \
      && rm -f /etc/cron.d/sanoid
  else
    echo "skipped, sanoid not available"
  fi

  echo "... syncoid"
  if command -v syncoid > /dev/null; then
    activateTimer "$etcHostDir/systemd/syncoid"
  else
    echo "skipped, syncoid not available"
  fi
fi
