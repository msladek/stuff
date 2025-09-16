#!/bin/bash

echo -e "\nSetup Jobs ..."
[ $EUID -ne 0 ] \
  && echo 'skipped, requires root' \
  && exit 1
! command -v systemctl >/dev/null \
  && ! systemctl status &>/dev/null \
  && echo 'skipped, systemd unavailable' \
  && exit 1

unitDir=/opt/msladek/stuff/etc/systemd
etcHostDir=/opt/msladek/stuffp/etc/$(hostname)

function installFile() {
  [ -f "$1" ] && [ -d "$2" ] \
    && install -m 644 -o root -g root "$1" "$2"
}

function installJobScript() {
  installFile "/opt/msladek/stuff/bin/jobs/$1" /usr/local/sbin/ \
    && chmod +x "/usr/local/sbin/$1"
}

function installUnit() {
  for unit in $1; do
    installFile "$unit" /etc/systemd/system/
  done
}

function installTimedService() {
  installJobScript "$(basename "$1")"
  [ -d "$(dirname "$1")" ] \
    && installUnit "${1}*.service" \
    && installUnit "${1}*.timer" \
    && systemctl daemon-reload
}

function installEnableTimedService() {
  installTimedService "$1" \
    && for timer in ${1}*.timer; do \
        systemctl enable --now "$(basename "$timer")"; \
       done
}

echo "... notify status" \
  && installJobScript notify-status \
  && installUnit $unitDir/notify-status@.service \
  && echo "done" || echo "FAILED"

echo "... check services" \
  && installTimedService $unitDir/check-ip \
  && installTimedService $unitDir/check-remote \
  && installEnableTimedService $unitDir/check-reboot \
  && echo "done" || echo "FAILED"

echo "... hosts file update"
installEnableTimedService $unitDir/hosts-update \
  && echo "done" || echo "FAILED"

echo "... filesytem trim"
installEnableTimedService $unitDir/fstrim \
  && echo "done" || echo "FAILED"

echo "... OS sync"
if [ -w /mnt/backup/os ]; then
  installEnableTimedService $unitDir/os-rsync \
    && echo "done" || echo "FAILED"
else
  echo "skipped, /mnt/backup/os not linked"
fi

echo "... smart attribute dump"
if [ -w /mnt/backup/smart ]; then
  installEnableTimedService $unitDir/smart-dump \
    && echo "done" || echo "FAILED"
else
  echo "skipped, /mnt/backup/smart not linked"
fi

if ! command -v zpool > /dev/null || [ "$(zpool list -H | wc -l)" -eq 0 ]; then
  echo "skipped zfs setup, no pools available"
else

  echo "... zfs multi-unlock"
  sudo wget -O /usr/local/sbin/zfs-multi-unlock \
      https://raw.githubusercontent.com/msladek/zfs-multi-unlock/master/zfs-multi-unlock.sh \
    && sudo chmod +x /usr/local/sbin/zfs-multi-unlock \
    && echo "done" || echo "FAILED"

  echo "... zfs health check"
  installEnableTimedService $unitDir/zfs-health \
    && echo "done" || echo "FAILED"

  echo "... zfs scrub"
  installEnableTimedService $unitDir/zfs-scrub \
    && rm -f /etc/cron.d/zfsutils-linux \
    && echo "done" || echo "FAILED"

  echo "... zfs keystatus"
  encryptedDatasets=$(zfs get encryptionroot -H -ovalue -tfilesystem | uniq | grep -v '-')
  if [ -n "$encryptedDatasets" ]; then
    installTimedService $unitDir/zfs-keystatus \
      && for dataset in $encryptedDatasets; do \
        zfs list -H -o name | grep -qF -- "${dataset}" \
          && echo "${dataset}" \
          && systemctl enable "zfs-keystatus@${dataset/\//_}.timer"; \
      done \
      && echo "done" || echo "FAILED"
  else
    echo "skipped, no encrypted datasets"
  fi

  if [ ! -d "$etcHostDir" ]; then
    echo "skipped, host dependent config, missing $etcHostDir"
  else
    echo "... sanoid"
    if [ -f "$etcHostDir/sanoid.conf" ]; then
      mkdir -p /etc/sanoid
      [ ! -f /etc/sanoid/sanoid.defaults.conf ] \
        && ln -s /usr/share/sanoid/sanoid.defaults.conf /etc/sanoid/sanoid.defaults.conf
      installFile "$etcHostDir/sanoid.conf" /etc/sanoid/ \
        && systemctl enable --now sanoid.timer \
        && rm -f /etc/cron.d/sanoid \
        && echo "done" || echo "FAILED"
    else
      echo "skipped, no sanoid.config"
    fi

    echo "... syncoidd"
    if [ -f "$etcHostDir/syncoidd.conf" ]; then
      installFile "$etcHostDir/syncoidd.conf" /etc/sanoid/ \
        && installEnableTimedService $unitDir/syncoidd \
        && echo "done" || echo "FAILED"
    else
      echo "skipped, no syncoidd.config"
    fi
  fi
fi
