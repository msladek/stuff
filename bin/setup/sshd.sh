#!/bin/bash

echo -e "\nSetup SSH Server ..."

sshdDir=/opt/stuff/private/etc/$(hostname)/sshd
[ -d "$sshdDir" ] \
  && sudo chown root:root ${sshdDir}/* \
  && sudo chmod 644 ${sshdDir}/* \
  && { [ ! -L "/etc/ssh/sshd_config.d" ] || sudo rm -v "/etc/ssh/sshd_config.d"; } \
  && sudo mkdir -p /etc/ssh/sshd_config.d \
  && sudo ln -sf ${sshdDir}/* /etc/ssh/sshd_config.d/ \
  || "skipped"
