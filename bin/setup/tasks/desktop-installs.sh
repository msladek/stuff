#!/bin/bash

echo -e "\nInstall desktop packages ..."
[ $EUID -ne 0 ] \
  && echo 'skipped, requires root' \
  && exit 1

echo -e "... tools ..."
apt -q=2 install \
    gnome-system-tools gnome-system-monitor gnome-disk-utility hardinfo gparted baobab \
    xsel wl-clipboard grub-customizer glances hfsprogs gvfs-backends gvfs-fuse solaar \
    kcolorchooser kooha screenruler stress sysbench x2goclient \
    chromium geany vlc gimp \
    pipewire pipewire-pulse pipewire-jack pipewire-alsa pipewire-audio

echo -e "... theming ..."
apt -q=2 install \
    papirus-icon-theme adwaita-icon-theme numix-icon-theme numix-icon-theme-circle \
    fonts-noto xfonts-terminus

wget -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-folders/master/install.sh | sh
papirus-folders -C orange

[[ "${XDG_CURRENT_DESKTOP,,}" == *"kde"* ]] \
  && echo -e "... kde ..." \
  && apt -q=2 install \
    plasma-workspace-wallpapers breeze breeze-cursor-theme breeze-icon-theme sddm-theme-breeze

[[ "${XDG_CURRENT_DESKTOP,,}" == *"xfce"* ]] \
  && echo -e "... xfce ..." \
  && apt -q=2 install \
    xfce4-goodies xfce4-whiskermenu-plugin xfce4-battery-plugin xfce4-clipman-plugin \
    xfce4-power-manager-plugins xfce4-pulseaudio-plugin xfce4-taskmanager xfce4-screenshooter \
    thunar-archive-plugin lightdm-gtk-greeter-settings numix-gtk-theme greybird-gtk-theme

function github-download-url() {
  local REPO="$1"
  local TAG_PREFIX="$2"
  local ASSET_TYPE="$3"
  local ASSET_PREFIX="$4"
  local api_url="https://api.github.com/repos/${REPO}/releases"
  local query_tags=".[] | select(.tag_name | startswith(\"${TAG_PREFIX}\"))"
  local query_assets="${query_tags} | .assets[] | select(.name | startswith(\"${ASSET_PREFIX}\") and endswith(\".${ASSET_TYPE}\"))"
  local query_download="${query_assets} | .browser_download_url"
  curl -sL "${api_url}" | jq -r "${query_download}" | head -n1
}

echo -e "\nInstall bitwarden ..."
# cli
tmpbw=/tmp/bw-cli.zip
wget -O "$tmpbw" $(github-download-url "bitwarden/clients" "cli-" "zip" "bw-linux-") \
  && unzip -d /usr/local/sbin "$tmpbw" \
  && chmod +x /usr/local/sbin/bw
rm -f "$tmpbw"

exit 0
