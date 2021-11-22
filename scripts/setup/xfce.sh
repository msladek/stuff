#!/bin/bash

echo -e "\nInstall XFCE packages ..."
sudo aptitude update > /dev/null && sudo aptitude install \
    thunar-archive-plugin lightdm-gtk-greeter-settings grub-customizer \
    xfce4-goodies xfce4-whiskermenu-plugin xfce4-battery-plugin xfce4-clipman-plugin \
    xfce4-power-manager-plugins xfce4-pulseaudio-plugin xfce4-taskmanager xfce4-screenshooter \
    numix-gtk-theme numix-icon-theme greybird-gtk-theme fonts-noto xfonts-terminus \
    adwaita-icon-theme papirus-icon-theme paper-cursor-theme \
  | egrep -v "is already installed|Reading |Writing |Building |Initializing "

echo -e "\nInstall Font Adobe Source Code Pro ..."
FONT_DIR="$HOME/.fonts/adobe-fonts/source-code-pro"
git clone --depth 1 --branch release https://github.com/adobe-fonts/source-code-pro.git $FONT_DIR \
	&& fc-cache -f -v $FONT_DIR \
  || echo "... skip, already setup"

echo -e "\nSetup Tiling..."
command -v quicktile &> /dev/null;
if (($? == 0)); then
     ln -sf ~/stuff/config/desktop/quicktile.cfg ~/.config/quicktile.cfg \
  && ln -sf ~/stuff/config/desktop/QuickTile.desktop ~/.config/autostart/QuickTile.desktop \
  || echo "... skip, already setup"
#  && ln -sf ~/stuff/config/desktop/xmodmap.cfg ~/.config/xmodmap.cfg
#  && ln -sf ~/stuff/config/desktop/XModMap.desktop ~/.config/autostart/XModMap.desktop
else
  echo "... skip, QuickTile not installed"
fi
