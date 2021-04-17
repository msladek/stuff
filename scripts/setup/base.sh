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

[ ! -d ~/config ] && echo "config dir not found" && exit 1
sudo chown -R $USER:$USER ~/config
echo -e "\nLink bash goodies ..."
ln -s ~/config/user/bash_aliases ~/.bash_aliases
grep -qF -- ".bash_aliases" ~/.bashrc \
    || echo "source ~/.bash_aliases" >> ~/.bashrc
grep -qF -- ".bashrc" ~/.bash_profile \
    || echo "source ~/.bashrc" >> ~/.bash_profile
ln -s ~/config/user/vimrc ~/.vimrc
ln -s ~/config/user/tmux.conf ~/.tmux.conf
    
echo -e "\nSetup private repo..."
git clone https://github.com/msladek/configp.git ~/config/private
[ -d ~/config/private ] \
  && chown -R $USER:$USER ~/config/private \
  && chmod -R go-rwx ~/config/private

echo -e "\nSetup SSH ..."
mkdir -p ~/.ssh
if [ -d ~/config/private ]; then
  ln -s ~/config/private/ssh/config ~/.ssh/config
  ln -s ~/config/private/ssh/keys/github ~/.ssh/github
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
  cd ~/config/private \
    && git remote set-url origin git@github.com:msladek/configp.git  
  cd ~/config \
    && git remote set-url origin git@github.com:msladek/config.git
fi

echo -e "\nEnable sudo insults ..."
echo -e 'Defaults insults' | sudo tee /etc/sudoers.d/insults > /dev/null
