#!/bin/bash
echo -e "Install firmware packages ..."
sudo aptitude -q=2 update && sudo aptitude -q=2 -y install \
    amd64-microcode intel-microcode firmware-linux firmware-linux-nonfree
