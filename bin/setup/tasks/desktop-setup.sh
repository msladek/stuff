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

echo -e "\nSetup bitwarden ..."
# cli bw
mkdir -p ~/bin
wget -O- $(github-download-url "bitwarden/clients" "cli-" "zip" "bw-linux-") \
  | busybox unzip -d ~/bin - \
  && chmod +x ~/bin/bw
wget -O ~/bin/bwx https://raw.githubusercontent.com/msladek/bwx/refs/heads/main/bwx.py  \
  && chmod +x ~/bin/bwx
ln -sf /opt/msladek/stuff/etc/user/bwx.yml ~/.config/bwx.yml
ln -sf /opt/msladek/stuff/bin/bwx-askpass.sh ~/bin/bwx-askpass
mkdir -p ~/.profile.d && chmod 740 ~/.profile.d \
  && ln -sf /opt/msladek/stuff/etc/user/profile/bwx.sh ~/.profile.d/80-bwx.sh
# desktop
tmpdeb=/tmp/bw-desktop.deb
wget -O "$tmpdeb" $(github-download-url "bitwarden/clients" "desktop-" "deb") \
  && sudo dpkg --skip-same-version -i "$tmpdeb"
rm -f "$tmpdeb"

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

exit 0
