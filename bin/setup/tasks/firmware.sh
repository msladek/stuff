#!/bin/bash
echo -e "\nSetup Install firmware packages ..."
[ $EUID -ne 0 ] \
  && echo 'skipped, requires root' \
  && exit 1

apt -q=2 -y install \
    amd64-microcode intel-microcode firmware-linux firmware-linux-nonfree
