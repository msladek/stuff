#!/bin/bash

echo -e "\nSetup SSH Server ..."

[ -d /opt/stuff/private/etc/$(hostname)/sshd ] \
  && sudo ln -sT /opt/stuff/private/etc/$(hostname)/sshd /etc/ssh/sshd_config.d \
  || "skipped"
