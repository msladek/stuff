#!/bin/bash

echo -e "\nSetup firewalld ..."
[ $EUID -ne 0 ] \
  && echo 'skipped, requires root' \
  && exit 1

! command -v firewall-cmd >/dev/null \
  && echo "... install firewalld" \
  && ! apt install firewalld \
  && echo "failed install" && exit 1

command -v sshd >/dev/null \
  && sshPort=$(sshd -T | grep port | head -n1 | cut -d' ' -f2) \
  && firewall-cmd --add-port=$sshPort/tcp --permanent \
  && firewall-cmd --reload
