#!/bin/bash

echo -e "\nSetup SSH Server ..."

[ -d /opt/stuff/private/etc/$(hostname)/sshd ] \
  && read -p "Setup sshd_config? (y/N) " && [[ $REPLY =~ ^[Yy]$ ]] \
  && sudo ln -sT /opt/stuff/private/etc/$(hostname)/sshd /etc/ssh/sshd_config.d
  || "skipped"
