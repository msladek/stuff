#!/bin/bash
if [ -w "/etc/hosts" ]; then
  customConf='10-custom.conf'
  blocklistConf='60-blocklist.conf'
  ## setup /etc/hosts.d
  mkdir -p /etc/hosts.d \
    && [ ! -f "/etc/hosts.d/$customConf" ] \
    && cp /etc/hosts /etc/hosts.d/$customConf \
    && echo "copied initial custom.conf"
  ## download blocklist and compile
  listURL='https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/gambling/hosts'
  curl -s $listURL | grep '^0.0.0.0 ' > /etc/hosts.d/$blocklistConf \
    && cat /etc/hosts.d/*.conf > /etc/hosts \
    && echo "hosts list updated"
fi
