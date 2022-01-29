#!/bin/bash

echo -e "\nSetup UFW ..."
[ $EUID -ne 0 ] \
  && echo 'skipped, requires root' \
  && exit 1

command -v ufw &> /dev/null \
  || aptitude install ufw \
  || echo "failed install" && exit 1
ufw default deny incoming
read -p "Allow 512/tcp (y/N)?" && [[ $REPLY =~ ^[Yy]$ ]] \
  && ufw limit 512/tcp comment 'ssh rate limit'
read -p "Enable Firewall (y/N)?" && [[ $REPLY =~ ^[Yy]$ ]] \
  && ufw enable
ufw status numbered
