#!/bin/bash

echo -e "\nInstall desktop packages ..."
sudo aptitude -q=2 update && sudo aptitude -q=2 install \
    openjdk-11-jdk openjdk-11-source openjdk-11-doc visualvm \
    gnome-system-tools gnome-system-monitor gnome-disk-utility \
    grub-customizer glances hfsprogs gvfs-backends gvfs-fuse \
    gufw gparted baobab chromium enpass geany vlc gimp clipit \
      | grep -v 'is already installed at the requested version'

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
    && ln -sf ~/stuff/services/ssh-agent.service ~/.config/systemd/user/ssh-agent.service \
    && systemctl --user enable ssh-agent \
    && systemctl --user start ssh-agent \
    || echo "... skip, already setup";;
esac

echo -e "\nInstall Font Adobe Source Code Pro ..."
FONT_DIR="$HOME/.fonts/adobe-fonts/source-code-pro"
FONT_URL_ADOBE='https://github.com/adobe-fonts/source-code-pro.git'
git clone --depth 1 --branch release $FONT_URL_ADOBE $FONT_DIR \
	&& fc-cache -f -v $FONT_DIR \
  || echo "... skip, already setup"

echo -e "\nSetup enpasscli ..."
sudo ln -sf /opt/stuff/bin/enpasscli /usr/local/bin/enpasscli
sudo ln -sf /opt/stuff/bin/enpass-askpass.sh /usr/local/bin/enpass-askpass
mkdir -p ~/.bash.d && chmod 740 ~/.bash.d \
  && ln -sf ~/stuff/config/user/bash/enpass.sh ~/.bash.d/80-enpass.sh
