#!/bin/bash

echo -e "\nInstall desktop packages ..."
[ $EUID -ne 0 ] \
  && echo 'skipped, requires root' \
  && exit 1

echo -e "... tools ..."
apt -q=2 install \
    gnome-system-tools gnome-system-monitor gnome-disk-utility hardinfo \
    xsel grub-customizer glances hfsprogs gvfs-backends gvfs-fuse solaar \
    gufw gparted baobab chromium enpass geany vlc gimp clipit gpick peek \
    openjdk-17-jdk openjdk-17-source openjdk-17-doc visualvm \
    steam stress sysbench x2goclient screenruler

echo -e "... theming ..."
apt -q=2 install \
    papirus-icon-theme adwaita-icon-theme numix-icon-theme numix-icon-theme-circle \
    fonts-noto xfonts-terminus

wget -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-folders/master/install.sh | sh
papirus-folders -C orange

[[ "${XDG_CURRENT_DESKTOP,,}" == *"kde"* ]] \
  && echo -e "... kde ..." \
  && apt -q=2 install \
    plasma-workspace-wallpapers sddm-theme-breeze 

[[ "${XDG_CURRENT_DESKTOP,,}" == *"xfce"* ]] \
  && echo -e "... xfce ..." \
  && apt -q=2 install \
    xfce4-goodies xfce4-whiskermenu-plugin xfce4-battery-plugin xfce4-clipman-plugin \
    xfce4-power-manager-plugins xfce4-pulseaudio-plugin xfce4-taskmanager xfce4-screenshooter \
    thunar-archive-plugin lightdm-gtk-greeter-settings numix-gtk-theme greybird-gtk-theme

exit 0
