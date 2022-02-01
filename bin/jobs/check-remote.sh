#!/bin/bash
#
# usage from e.g. crontab:
#  *  *  *  *  * root	/opt/msladek/stuff/bin/jobs/check-remote.sh saturn.sladek.co 512
#

die() {
  echo >&2 "failed - $@"; exit 1;
}

sendMail() {
  echo -e "Subject: $1\n\n$2" | msmtp root@sladek.co
}

[[ "${1}" =~ ^[a-zA-Z\.].*$ ]]  && host="$1" || die "invalid host $1" 
[[ "${2}" =~ ^[0-9]{2,5}$ ]]    && port="$2" || die "invalid port $2" 
name="check-remote-${host}-${port}"
log="/var/log/$name.log"
lock="/var/lock/$name.lock"
touch $log

currDate=$(date +"%Y-%m-%d %H:%M")
wget -q -T 10 --spider http://google.com && isLocalUp=true  || isLocalUp=false
nc -z $host $port -w 10  &>/dev/null     && isRemoteUp=true || isRemoteUp=false
test -f $lock                            && existsLock=true || existsLock=false

if ! $isLocalUp; then
  echo "[${currDate}] unable to check remote, no connection..." | tee -a $log
elif $isRemoteUp; then
  if $existsLock; then
    downDate=$(cat $lock)
    subject="[INFO] ${host} online"
    message="${host}:${port} is back online from $(hostname), was down between ${downDate} and ${currDate}"
    sendMail "$subject" "$message"
    rm $lock
    echo "[${currDate}] ${message}" | tee -a $log
  elif [ $(date +"%M") == "00" ]; then
    echo "[${currDate}] ${host}:${port} is online" | tee -a $log
  fi
else
  if $existsLock; then
    echo "[${currDate}] ${host}:${port} still offline, waiting..." | tee -a $log
  else
    echo $currDate > $lock
    subject="[URGENT] ${host} offline"
    message="${host}:${port} went offline from $(hostname) at ${currDate}"
    sendMail "$subject" "$message"
    echo "[${currDate}] ${message}" | tee -a $log
  fi
fi

exit 0
