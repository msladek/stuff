#!/bin/bash

echo -e "\nSetup UFW ..."
[ $EUID -ne 0 ] \
  && echo 'skipped, requires root' \
  && exit 1

! command -v ufw >/dev/null \
  && ! aptitude install ufw \
  && echo "failed install" && exit 1

if ! ufw status | grep -qF active; then
  ufw default deny incoming
  command -v sshd >/dev/null \
    && sshPort=$(sshd -T | grep port | head -n1 | cut -d' ' -f2) \
    && ! grep -qF -- "tcp $sshPort" /lib/ufw/user.rules
    && ufw limit $sshPort/tcp comment 'ssh rate limit'
  ufw enable
fi 
