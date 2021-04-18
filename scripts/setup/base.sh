#!/bin/bash

command -v aptitude &> /dev/null;
if (($? != 0)); then
  echo -e "\nInstall aptitude ..."
  sudo apt update && sudo apt install aptitude
fi

echo -e "\nUpgrade system ..."
sudo aptitude update > /dev/null && sudo aptitude upgrade

echo -e "Install essentials packages ..."
sudo aptitude install \
    sudo bash-completion apt-listbugs apt-listchanges apt-transport-https \
    net-tools netcat ethtool curl wget dnsutils iotop iftop openssh-client \
    debian-goodies debian-keyring gnupg dirmngr lsb-release ca-certificates \
    ntp git tree pv dstat vim rsync htop screen tmux sshfs smartmontools \
    mc zip unzip unrar-free zip unzip unrar-free software-properties-common build-essential \
  | egrep -v "is already installed|Reading |Writing |Building |Initializing "

[ ! -d ~/stuff ] && echo "stuff not found" && exit 1
sudo chown -R $USER:$USER ~/stuff
echo -e "\nLink bash goodies ..."
ln -sf ~/stuff/config/user/bash_aliases ~/.bash_aliases
grep -qF -- ".bash_aliases" ~/.bashrc \
    || echo "source ~/.bash_aliases" >> ~/.bashrc
grep -qF -- ".bashrc" ~/.bash_profile \
    || echo "source ~/.bashrc" >> ~/.bash_profile
ln -sf ~/stuff/config/user/vimrc ~/.vimrc
ln -sf ~/stuff/config/user/tmux.conf ~/.tmux.conf

if [ ! -d ~/stuff/private ]; then
  echo
  read -p "Setup private repo? (y/N) " choice
  case "$choice" in
   y|Y ) git clone https://github.com/msladek/stuffp.git ~/stuff/private;;
  esac
fi
[ -d ~/stuff/private ] \
  && chown -R $USER:$USER ~/stuff/private \
  && chmod -R go-rwx ~/stuff/private

echo -e "\nSetup SSH ..."
mkdir -p ~/.ssh
if [ -d ~/stuff/private ]; then
  ln -s ~/stuff/private/ssh/config ~/.ssh/config
  ln -s ~/stuff/private/ssh/keys/github ~/.ssh/github
else
  echo "skipped, private repo missing"
fi
chown $USER:$USER ~/.ssh
chmod -f 700 ~/.ssh
chmod -f 600 ~/.ssh/*
chmod -f 644 ~/.ssh/*.pub

echo -e "\nSetup Git config ..."
git config --global core.editor "vim"
git config --global pull.rebase false
if [ -f ~/.ssh/github ]; then
  git config --global core.sshCommand "ssh -i ~/.ssh/github -F /dev/null"
  cd ~/stuff/private \
    && git remote set-url origin git@github.com:msladek/stuffp.git  
  cd ~/stuff \
    && git remote set-url origin git@github.com:msladek/stuff.git
fi

echo -e "\nEnable sudo insults ..."
echo -e 'Defaults insults' | sudo tee /etc/sudoers.d/insults > /dev/null
