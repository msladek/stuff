#!/bin/bash
echo -e "\nInstalling packages ..."
[ $EUID -ne 0 ] \
  && echo 'skipped, requires root' \
  && exit 1

if ! command -v aptitude > /dev/null; then
  echo -e "... install aptitude"
  apt -q=2 update && apt install aptitude
fi

echo -e "... upgrade system"
aptitude -q=2 update > /dev/null && aptitude -q=2 -y upgrade

echo -e "... install essentials packages"
aptitude -q=2 -y install \
    doas bash-completion apt-listchanges apt-transport-https \
    net-tools netcat ethtool curl wget dnsutils iotop iftop openssh-client \
    debian-goodies debian-keyring gnupg dirmngr lsb-release ca-certificates \
    ntp git tree pv dstat bat vim rsync htop tmux sshfs smartmontools ncdu \
    colordiff zip unzip unrar-free unp software-properties-common build-essential \
      | grep -v 'is already installed at the requested version'

if [ $(lsb_release -sc) = 'sid' ] && ! command -v apt-listbugs > /dev/null; then
  echo -e "... install apt-listbugs"
  aptitude -q=2 -y install apt-listbugs
fi

echo -e "... clean packages"
aptitude autoclean
apt autoremove 

function github-install-latest() {
  echo -e "Installing $1 from github ..."
  local release_url="https://github.com/$1/releases/latest"
  local current_version=$(curl -s $release_url | grep -o -P '(?<=releases/tag/).*(?=\">)')
  local download_url="$release_url/download/$(echo $2 | sed "s|%s|$current_version|g")"
  local tmp_deb="$(mktemp)" \
    && wget --no-verbose --output-document "$tmp_deb" "$download_url" \
    && dpkg --skip-same-version -i "$tmp_deb"
  local exit_code=$?
  rm -f "$tmp_deb"
  return $exit_code
}

echo -e "... install lsd"
github-install-latest 'Peltoche/lsd' 'lsd-musl_%s_amd64.deb'
