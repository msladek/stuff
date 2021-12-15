#!/bin/bash

command -v aptitude &> /dev/null;
if (($? != 0)); then
  echo -e "\nInstall aptitude ..."
  sudo apt update && sudo apt install aptitude
fi

echo -e "\nUpgrade system ..."
sudo aptitude update > /dev/null && sudo aptitude -y upgrade

echo -e "Install essentials packages ..."
sudo aptitude -y install \
    sudo bash-completion apt-listbugs apt-listchanges apt-transport-https \
    net-tools netcat ethtool curl wget dnsutils iotop iftop openssh-client \
    debian-goodies debian-keyring gnupg dirmngr lsb-release ca-certificates \
    ntp git tree pv dstat bat vim rsync htop screen tmux sshfs smartmontools \
    diff colordiff zip unzip unrar-free unp software-properties-common build-essential \
  | egrep -v "is already installed|Reading |Writing |Building |Initializing "

function github-install-latest() {
  echo -e "Installing $1 from github ..."
  local release_url="https://github.com/$1/releases/latest"
  local current_version=$(curl -s $release_url | grep -o -P '(?<=releases/tag/).*(?=\">)')
  local download_url="$release_url/download/$(echo $2 | sed "s|%s|$current_version|g")"
  local tmp_deb="$(mktemp)" \
    && wget --no-verbose --show-progress --output-document "$tmp_deb" "$download_url" \
    && sudo dpkg --skip-same-version -i "$tmp_deb"
  local exit_code=$?
  rm -f "$tmp_deb"
  return $exit_code
}

github-install-latest 'Peltoche/lsd' 'lsd-musl_%s_amd64.deb'

unset github-install-latest

