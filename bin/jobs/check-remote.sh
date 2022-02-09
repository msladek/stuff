#!/bin/bash

authority="$1"
lock="/var/lock/check-remote@${authority}.lock"
#  %s - seconds since 1970-01-01 00:00:00 UTC 
currTimestamp=$(date +%s)
wget -q -T 10 --spider http://google.com && isLocalUp=true || isLocalUp=false
nc -z ${authority/:/ } -w 10             && isRemoteUp=true || isRemoteUp=false
! test -r $lock                          && wasRemoteUp=true || wasRemoteUp=false

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
  exit 2 # fail here to send notification 
fi
exit 0
