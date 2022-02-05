#!/bin/bash

die() {
  echo >&2 "failed - $@"; exit 1;
}

source /etc/profile
# PUBLIC_IP should be set in /etc/profile.d/
[[ "${PUBLIC_IP}." =~ ^([0-9]{1,3}\.){4}$ ]] \
  || die "expected valid env variable PUBLIC_IP" 
name="check-ip"
log="/var/log/$name.log"
touch $log

actualIp=$(curl -s ipinfo.io/ip)
currDate=$(date +"%Y-%m-%d %H:%M")

if [ "$PUBLIC_IP" != "$actualIp" ]; then
  subject="[URGENT] $(hostname) IP reassigned"
  message="I, $(hostname), have been assigned the new IP ${actualIp} at ${currDate} from previous IP ${PUBLIC_IP}"
  echo -e "Subject: ${subject}\n\n${message}" | sendmail root@sladek.co
  echo "[${currDate}] ${message}" | tee -a $log
else
  echo "[${currDate}] $(hostname) still has IP $actualIp" | tee -a $log
fi

exit 0
