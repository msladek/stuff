#!/bin/bash
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail

echo -e "\nInstalling packages ..."
[ $EUID -ne 0 ] \
  && echo 'skipped, requires root' \
  && exit 1

echo -e "... upgrade system"
apt -q=2 update > /dev/null && apt -q=2 -y upgrade

echo -e "... install essentials packages"
apt -q=2 -y install \
    sudo bash-completion apt-listchanges apt-transport-https unattended-upgrades \
    net-tools netcat-openbsd ethtool curl wget dnsutils iotop iftop openssh-client \
    debian-goodies debian-keyring gnupg dirmngr lsb-release ca-certificates systemd-cron \
    systemd-timesyncd git tree pv dstat bat vim rsync htop tmux sshfs ncdu colordiff lsd usbutils \
    fzf fd-find zip unzip unrar-free unp software-properties-common build-essential

if [ $(lsb_release -sc) = 'sid' ]; then
  ! command -v apt-listbugs > /dev/null \
    && echo -e "... install apt-listbugs" \
    && apt -q=2 -y install apt-listbugs
elif command -v debian-security-support > /dev/null; then
  echo -e "... install security-support" \
  apt -q=2 -y install debian-security-support
fi

echo -e "... clean packages"
apt autoremove

function github-install-latest() {
  echo -e "Installing $1 from github ..."
  local api_url="https://api.github.com/repos/$1/releases/latest"
  local download_url=$(curl -sL $api_url | grep -F 'download_url' | grep -E "$2" | sed "s/\"//g" | cut -d: -f2-)
  local tmp_deb="$(mktemp)" \
    && wget --no-verbose --output-document "$tmp_deb" "$download_url" \
    && dpkg --skip-same-version -i "$tmp_deb"
  local exit_code=$?
  rm -f "$tmp_deb"
  return $exit_code
}
