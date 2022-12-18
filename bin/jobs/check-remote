#!/bin/bash

authority="$1"
lock="/var/lock/check-remote@${authority}.lock"
#  %s - seconds since 1970-01-01 00:00:00 UTC 
currTimestamp=$(date +%s)
ping -w10 -c1 dns.google.com >/dev/null && isLocalUp=true || isLocalUp=false
nc -z ${authority/:/ } -w 10            && isRemoteUp=true || isRemoteUp=false
! test -r $lock                         && wasRemoteUp=true || wasRemoteUp=false

if ! $isLocalUp; then
  echo "unable to check remote, no connection"
elif ! $isRemoteUp; then
  if $wasRemoteUp; then
    echo "$currTimestamp" > $lock
    echo "went offline"
  fi
  exit 1
elif ! $wasRemoteUp; then
  currDate=$(date --date="@${currTimestamp}" +"%Y-%m-%d %H:%M")
  downDate=$(date --date="@$(cat $lock)" +"%Y-%m-%d %H:%M")
  echo "back online, was down between ${downDate} and ${currDate}"
  rm $lock
  exit 55 # fail with 55 here to send notification regardless
fi
exit 0
