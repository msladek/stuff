#!/bin/sh
## run within screen/tmux session as root

updateAptList () {
  [ -f "$1" ] && \
  sed -i 's/buster/bullseye/g' $1 && \
  sed -i 's/bullseye\/updates/bullseye-security/g' $1 && \
  echo "updated to bullseye in $1"
}

aptitude update && \
aptitude upgrade \
 || exit 1

updateAptList /etc/apt/sources.list
updateAptList /etc/apt/sources.list.d/hetzner-mirror.list
updateAptList /etc/apt/sources.list.d/hetzner-security-updates.list
updateAptList /etc/apt/sources.list.d/google-cloud.list
updateAptList /etc/apt/sources.list.d/gce_sdk.list

aptitude update && \
aptitude upgrade && \
aptitude dist-upgrade && \
aptitude autoclean && \
reboot \
 || exit 1
 
exit 0

