#!/bin/bash
subject="[$(hostname)] systemd unit status"
message="$(systemctl status ${1})"
echo -e "Subject: ${subject}\n\n${message}" | sendmail root
