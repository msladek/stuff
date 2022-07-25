#!/bin/bash

echo -e "\nSetup desktop user stuff ..."
[ $EUID -eq 0 ] \
  && echo 'skipped, requires non-root' \
  && exit 1

echo
if command -v systemctl >/dev/null && systemctl status &>/dev/null; then
  read -p "Setup SSH agent service (Y/n) ?" choice
  case "$choice" in
    n|N ) ;;
    * ) mkdir -p ~/.config/systemd/user \
      && ln -sf /opt/msladek/stuff/etc/systemd/ssh-agent.service ~/.config/systemd/user/ssh-agent.service \
      && systemctl --user daemon-reload \
      && systemctl --user enable --now ssh-agent \
      || echo "... skip, already setup";;
  esac
fi

echo -e "\nInstall Font Adobe Source Code Pro ..."
FONT_DIR=~/.fonts/adobe-fonts/source-code-pro
FONT_URL_ADOBE=https://github.com/adobe-fonts/source-code-pro.git
git clone --depth 1 --branch release $FONT_URL_ADOBE $FONT_DIR \
	&& fc-cache -f -v $FONT_DIR \
  || echo "... skip, already setup"

echo -e "\nSetup enpasscli ..."
mkdir -p ~/bin
ln -sf /opt/msladek/stuff/bin/enpasscli ~/bin/enpasscli
ln -sf /opt/msladek/stuff/bin/enpass-askpass.sh ~/bin/enpass-askpass
mkdir -p ~/.profile.d && chmod 740 ~/.profile.d \
  && ln -sf /opt/msladek/stuff/etc/user/profile/enpass.sh ~/.profile.d/80-enpass.sh

echo -e "\nSetup Tiling..."
if command -v quicktile > /dev/null; then
     ln -sf /opt/msladek/stuff/etc/user/quicktile.cfg ~/.config/quicktile.cfg \
  && ln -sf /opt/msladek/stuff/etc/user/autostart/QuickTile.desktop ~/.config/autostart/QuickTile.desktop \
  || echo "... skip, already setup"
#  && ln -sf /opt/msladek/stuff/etc/user/xmodmap.cfg ~/.config/xmodmap.cfg
#  && ln -sf /opt/msladek/stuff/etc/user/autostart/XModMap.desktop ~/.config/autostart/XModMap.desktop
else
  echo "... skip, QuickTile not installed"
fi

exit 0
