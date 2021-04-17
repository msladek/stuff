#!/bin/bash
echo -e "Install firmware packages ..."
sudo aptitude install  \
    amd64-microcode intel-microcode firmware-linux firmware-linux-nonfree \
  | egrep -v "is already installed|Reading |Writing |Building |Initializing "
