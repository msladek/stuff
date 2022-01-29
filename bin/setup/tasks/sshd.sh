#!/bin/bash

echo -e "\nSetup SSH server ..."
[ $EUID -ne 0 ] \
  && echo 'skipped, requires root' \
  && exit 1

sshdDir=/opt/stuff/private/etc/$(hostname)/sshd
[ -d "$sshdDir" ] \
  && chown root:root ${sshdDir}/* \
  && chmod 644 ${sshdDir}/* \
  && { [ ! -L "/etc/ssh/sshd_config.d" ] || rm -v "/etc/ssh/sshd_config.d"; } \
  && mkdir -p /etc/ssh/sshd_config.d \
  && ln -sf ${sshdDir}/* /etc/ssh/sshd_config.d/ \
  || "skipped"

exit 0
