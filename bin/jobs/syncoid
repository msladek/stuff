#!/bin/bash
echo "${@:(-2):1} -> ${@:(-1):1}"
args=( "$@" )
[ "$1" == "-b" ] && args=( "--create-bookmark" "${@:2}" )
/usr/sbin/syncoid \
  --no-privilege-elevation \
  --no-forced-receive \
  --no-sync-snap \
  --skip-parent \
  "${args[@]}"
