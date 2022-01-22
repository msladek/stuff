#!/bin/bash
## e.g. p53/test@auto_monthly-2022-01-22-1232 -> p53/test@autosnap_2022-01-22_12:32:00_monthly
## $1: 's/auto_([a-z]*)-([0-9\-]*)-([0-9]{2})([0-9]{2})$/autosnap_\2_\3:\4:00_\1/'
## $2: 'p53/test@auto_'
[ -z "$1" ] && echo 'no sed statement provided' && exit 1
[ -z "$2" ] && echo 'no grep statement provided' && exit 1
for oldname in $(zfs list -H -t snapshot -o name | grep "$2"); do
  newname=$(echo $oldname | sed -E "$1")
  [ -n "$newname" ] && [ "$newname" != "$oldname" ] \
    && echo "$oldname -> $newname" \
    && [ "$doItNow" == "true" ] \
    && sudo zfs rename $oldname $newname
done
