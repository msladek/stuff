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
    ntp git tree pv dstat vim rsync htop screen tmux sshfs smartmontools \
    mc zip unzip unrar-free zip unzip unrar-free software-properties-common build-essential \
  | egrep -v "is already installed|Reading |Writing |Building |Initializing "
