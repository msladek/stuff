#!/bin/bash

echo -e "\nSetup sudo ..."
[ $EUID -ne 0 ] \
  && echo 'skipped, requires sudo' \
  && exit 1

if command -v sudo > /dev/null; then
  echo -e "Enable sudo insults ..."
  echo -e 'Defaults insults' | tee /etc/sudoers.d/insults > /dev/null
  chmod o-rwx /etc/sudoers.d/insults
fi

if command -v doas > /dev/null; then
  echo -e "Enable doas ..."
  echo -e "permit persist ${SUDO_USER:-$USER} as root" | tee /etc/doas.conf > /dev/null
  chmod o-rwx /etc/doas.conf
fi

exit 0
