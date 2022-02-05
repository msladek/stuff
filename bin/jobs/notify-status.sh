#!/bin/bash
subject="[$(hostname)] [systemd] $1"
message="$(systemctl status ${1})"
echo -e "Subject: ${subject}\n\n${message}" | sendmail root
