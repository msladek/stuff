#!/bin/bash
echo "${@:(-2):1} -> ${@:(-1):1}"
/usr/sbin/syncoid \
  --no-privilege-elevation \
  --no-sync-snap \
  --create-bookmark \
  --recursive \
  --skip-parent \
  $@
