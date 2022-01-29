#!/bin/bash

echo -e "\nSetup sudo ..."
[ $EUID -ne 0 ] \
  && echo 'skipped, requires sudo' \
  && exit 1

echo -e "Enable sudo insults ..."
echo -e 'Defaults insults' | tee /etc/sudoers.d/insults > /dev/null
chmod o-rwx /etc/sudoers.d/insults

echo -e "Enable doas ..."
echo -e "permit persist $USER as root" | tee /etc/doas.conf > /dev/null
chmod o-rwx /etc/doas.conf

exit 0
