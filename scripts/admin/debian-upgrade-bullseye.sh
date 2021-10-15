#!/bin/bash

updateAptList () {
  [ -f "$1" ] && \
  sed -i 's/buster/bullseye/g' $1 && \
  sed -i 's/bullseye\/updates/bullseye-security/g' $1 && \
  echo "updated to bullseye in $1"
}

[[ "${TERM:0:6}" != 'screen' ]] \
 && echo 'exit: run within screen/tmux' \
 && exit 1

apt update && \
apt upgrade \
 || exit 1

echo
read -p 'Upgrade buster -> bullseye now? (y/N) ' && [[ $REPLY =~ ^[Yy]$ ]] \
 || exit 1

echo
updateAptList /etc/apt/sources.list
updateAptList /etc/apt/sources.list.d/hetzner-mirror.list
updateAptList /etc/apt/sources.list.d/hetzner-security-updates.list
updateAptList /etc/apt/sources.list.d/google-cloud.list
updateAptList /etc/apt/sources.list.d/gce_sdk.list

echo
apt update && \
apt upgrade && \
apt full-upgrade && \
apt autoremove && \
apt autoclean \
 || exit 1

echo
read -p 'Reboot now? (y/N) ' && [[ $REPLY =~ ^[Yy]$ ]] \
 && reboot
 
exit 0
