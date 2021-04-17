#!/bin/bash
echo -e "Setup UFW ..."
command -v ufw &> /dev/null \
  || sudo aptitude install ufw \
  || (echo "failed install" && exit 1)
sudo ufw default deny incoming
read -p "Allow 512/tcp (y/N)?" choice
case "$choice" in
  y|Y ) sudo ufw limit 512/tcp comment 'ssh rate limit';;
esac
read -p "Enable Firewall (y/N)?" choice
case "$choice" in
  y|Y ) sudo ufw enable;;
esac
sudo ufw status numbered
