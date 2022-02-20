#!/bin/bash
[ -z "${1}" ] && echo >&2 "empty service name" && exit 1
service="$1"
dateFile="/tmp/notify-status@${service}.timestamp"

#  %s - seconds since 1970-01-01 00:00:00 UTC 
currDate=$(date +%s)
[ -r $dateFile ] && lastDate=$(cat $dateFile)
[ -z $lastDate ] && lastDate=0
exitStatus=$(systemctl show ${service} | grep ExecMainStatus | cut -d'=' -f2)
if [ "$exitStatus" = '55' ]; then
  echo "received status 55, always sending"
# 86400s = 60s * 60 * 24 = 24h
elif [ $((currDate - lastDate)) -lt 86400 ]; then
  echo "skip, already notified at ${lastDate}"
  exit 0
fi

subject="[$(hostname)] systemd ${service}"
message="$(systemctl status ${service})"
echo -e "Subject: ${subject}\n\n${message}" \
   | sendmail root \
  && echo $currDate > $dateFile \
  && echo "notified at ${currDate}"
