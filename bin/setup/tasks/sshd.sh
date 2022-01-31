#!/bin/bash

echo -e "\nSetup SSH server ..."
[ $EUID -ne 0 ] \
  && echo 'skipped, requires root' \
  && exit 1

sshdConfDir=/opt/msladek/stuffp/etc/$(hostname)/sshd
[ -d "$sshdConfDir" ] \
  && chown root $sshdConfDir && chmod 1775 $sshdConfDir \
  && chown root $sshdConfDir/* && chmod 644 $sshdConfDir/* \
  && { [ ! -L "/etc/ssh/sshd_config.d" ] || rm -v "/etc/ssh/sshd_config.d"; } \
  && mkdir -p /etc/ssh/sshd_config.d \
  && ln -sf $sshdConfDir/* /etc/ssh/sshd_config.d/ \
  || echo "skipped" # TODO reasonable base setup?

exit 0
