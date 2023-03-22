#!/bin/bash

echo -e "\nSetup sudo ..."
[ $EUID -ne 0 ] \
  && echo 'skipped, requires sudo' \
  && exit 1

if command -v sudo > /dev/null; then
  echo -e "Enable sudo insults ..."
  echo -e 'Defaults insults' | tee /etc/sudoers.d/insults > /dev/null
  chmod 0440 /etc/sudoers.d/insults
fi

if command -v doas > /dev/null; then
  echo -e "Enable doas ..."
  echo -e "permit persist ${SUDO_USER:-$USER} as root" | tee /etc/doas.conf > /dev/null
  chmod o-rwx /etc/doas.conf
fi

apt-cache policy | grep -qF 'o=Docker' \
  && ! grep -qF 'o=Docker' /etc/apt/apt.conf.d/52unattended-upgrades-custom \
  && echo 'Unattended-Upgrade::Origins-Pattern { "o=Docker,a=${distro_codename}"; };' \
  | sudo tee -a /etc/apt/apt.conf.d/52unattended-upgrades-custom

exit 0
