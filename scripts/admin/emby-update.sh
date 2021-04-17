#!/bin/bash

tmp_deb="emby-server-deb_latest_amd64.deb"
url_latest="https://api.github.com/repos/MediaBrowser/Emby.Releases/releases/latest"
url_dl="$(curl -s $url_latest | grep browser_download_url | grep emby-server-deb | grep amd64 | cut -d '"' -f 4)"

wget -O $tmp_deb $url_dl \
  && sudo service emby-server stop \
  && sudo dpkg -i $tmp_deb \
  && rm -f $tmp_deb \
  && sudo service emby-server start

