#!/bin/bash
subject="[IMPORTANT] [$(hostname)] systemd unit status"
systemctl cat "${1}" &> /dev/null ] \
  && message="$(systemctl status \"${1}\")" \
  || message="called with unknown service name \"${1}\""
echo -e "Subject: ${subject}\n\n${message}" | sendmail root
