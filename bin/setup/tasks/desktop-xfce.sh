#!/bin/bash

echo -e "\nInstall XFCE packages ..."
[ $EUID -ne 0 ] \
  && echo 'skipped, requires root' \
  && exit 1

aptitude -q=2 update && aptitude -q=2 install \
    thunar-archive-plugin lightdm-gtk-greeter-settings \
    xfce4-goodies xfce4-whiskermenu-plugin xfce4-battery-plugin xfce4-clipman-plugin \
    xfce4-power-manager-plugins xfce4-pulseaudio-plugin xfce4-taskmanager xfce4-screenshooter \
    numix-gtk-theme numix-icon-theme greybird-gtk-theme fonts-noto xfonts-terminus \
    adwaita-icon-theme papirus-icon-theme paper-cursor-theme \
      | grep -v 'is already installed at the requested version'

exit 0
