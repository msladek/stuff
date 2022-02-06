#!/bin/bash
[ -z "${1}" ] && echo >&2 "empty service name" && exit 1
service="$1"
dateFile="/tmp/notify-status-${service}.timestamp"

#  %s - seconds since 1970-01-01 00:00:00 UTC 
currDate=$(date +%s)
[ -r $dateFile ] && lastDate=$(cat $dateFile)
[ -z $lastDate ] && lastDate=0
# 86400s = 60s * 60 * 24 = 24h
if [ $((currDate - lastDate)) -lt 86400 ]; then
  echo "skip, already notified at ${lastDate}"
  exit 0
fi

subject="[$(hostname)] systemd ${service}"
message="$(systemctl status ${service})"
echo -e "Subject: ${subject}\n\n${message}" \
   | sendmail root \
  && echo $currDate > $dateFile
