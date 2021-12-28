#!/bin/bash

echo -e "\nInstall XFCE packages ..."
sudo aptitude -q=2 update && sudo aptitude -q=2 install \
    thunar-archive-plugin lightdm-gtk-greeter-settings \
    xfce4-goodies xfce4-whiskermenu-plugin xfce4-battery-plugin xfce4-clipman-plugin \
    xfce4-power-manager-plugins xfce4-pulseaudio-plugin xfce4-taskmanager xfce4-screenshooter \
    numix-gtk-theme numix-icon-theme greybird-gtk-theme fonts-noto xfonts-terminus \
    adwaita-icon-theme papirus-icon-theme paper-cursor-theme \
      | grep -v 'is already installed at the requested version'

echo -e "\nSetup Tiling..."
if command -v quicktile > /dev/null; then
     ln -s ~/stuff/config/desktop/quicktile.cfg ~/.config/quicktile.cfg \
  && ln -s ~/stuff/config/desktop/QuickTile.desktop ~/.config/autostart/QuickTile.desktop \
  || echo "... skip, already setup"
#  && ln -s ~/stuff/config/desktop/xmodmap.cfg ~/.config/xmodmap.cfg
#  && ln -s ~/stuff/config/desktop/XModMap.desktop ~/.config/autostart/XModMap.desktop
else
  echo "... skip, QuickTile not installed"
fi
