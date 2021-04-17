#!/bin/bash

echo -e "\nInstall desktop packages ..."
sudo aptitude update > /dev/null && sudo aptitude install \
    openjdk-11-jdk openjdk-11-source openjdk-11-doc visualvm \
    gnome-system-tools gnome-system-monitor gnome-disk-utility \
    glances hfsprogs gvfs-backends gvfs-fuse \
    gufw gparted baobab chromium enpass geany vlc gimp clipit \
  | egrep -v "is already installed|Reading |Writing |Building |Initializing "

echo
echo -e "Setup Desktop Git config ..."
git config --global user.name "Marc Sladek"
git config --global user.email "marc@sladek.me"
git config --global user.signingkey 8C64BE4EC6D00407
git config --global commit.gpgsign true
githubGPG=$HOME/.ssh/github_gpg
[ -f "$githubGPG" ] \
  && gpg --import "${githubGPG}.pub" \
  && gpg --import "$githubGPG" \
  || echo "WARNING: no gpg keys found, please import manually."

echo
read -p "Setup SSH agent service (Y/n)?" choice
case "$choice" in
  n|N ) ;;
  * ) mkdir -p ~/.config/systemd/user \
    && ln -s ~/config/services/ssh-agent.service ~/.config/systemd/user/ssh-agent.service \
    && systemctl --user enable ssh-agent \
    && systemctl --user start ssh-agent \
    || echo "... skip, already setup";;
esac
