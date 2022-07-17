#!/bin/bash
echo 'importing zfs-tools ...'

echo '... zfs-dataset-substitute($mountpoint $fromDataset $toDataset)'
function zfs-dataset-substitute() {
  [ -z "$1" ] && echo 'no mountpoint provided' && return 1
  [ -z "$3" ] && echo 'no toDataset provided' && return 1
  if [ ! -z "$2" ] && [ $2 != 'none' ]; then
    [ "$1" != "$(zfs get -H -o value mountpoint $2)" ] \
      && echo "fromDataset [${2}] not mounted at [${1}]" && return 1
    zfs set mountpoint=none $2
  fi
  zfs set mountpoint="$1" $3
}

echo '... zfs-dataset-forEach($command [$postCommand])'
function zfs-dataset-forEach() {
  [ -z "$1" ] && echo 'no command provided' && return 1
  for dataset in $(zfs list -H -o name); do
    $1 $dataset $2
  done
}

echo '... zfs-snaps-forEach($dataset $command [$postCommand])'
function zfs-snaps-forEach() {
  [ -z "$1" ] && echo 'no dataset provided' && return 1
  [ -z "$2" ] && echo 'no command provided' && return 1
  for snap in $(zfs list -H -t snapshot -o name -s creation $1); do
    $2 $snap $3
  done
}

echo '... zfs-snaps-first($dataset)'
function zfs-snaps-first() {
  [ -z "$1" ] && echo 'no dataset provided' && return 1
  snap=$(zfs list -H -t snapshot -o name -s creation $1 | head -n1)
  echo "[$1] ${snap:-none}"
}

echo '... zfs-snaps-last($dataset)'
function zfs-snaps-last() {
  [ -z "$1" ] && echo 'no dataset provided' && return 1
  snap=$(zfs list -H -t snapshot -o name -s creation $1 | tail -n1)
  echo "[$1] ${snap:-none}"
}

echo '... zfs-snaps-rename($sedReplace $grepFilter)'
## e.g. p53/test@auto_monthly-2022-01-22-1232 -> p53/test@autosnap_2022-01-22_12:32:00_monthly
## $sedReplace: 's/auto_([a-z]*)-([0-9\-]*)-([0-9]{2})([0-9]{2})$/autosnap_\2_\3:\4:00_\1/'
## $grepFilter: 'p53/test@auto_'
function zfs-snaps-rename() {
  [ -z "$1" ] && echo 'no sed replace provided' && return 1
  [ -z "$2" ] && echo 'no grep filter provided' && return 1
  [ "$doItNow" == "true" ] || echo >&2 "DRY-RUN, set doItNow=true"
  for oldname in $(zfs list -H -t snapshot -o name | grep "$2"); do
    newname=$(echo $oldname | sed -E "$1")
    [ -n "$newname" ] && [ "$newname" != "$oldname" ] \
      && echo "$oldname -> $newname" \
      && [ "$doItNow" == "true" ] \
      && zfs rename $oldname $newname
  done
  unset doItNow
}

echo '... zfs-snaps-destroy($grepFilter)'
## $grepFilter: '@syncoid_'
function zfs-snaps-destroy() {
  [ -z "$1" ] && echo 'no grep filter provided' && return 1
  [ "$doItNow" == "true" ] || echo >&2 "DRY-RUN, set doItNow=true"
  for snap in $(zfs list -H -t snapshot -o name | grep "$1"); do
    [ -n "$snap" ] \
      && echo "deleting: $snap" \
      && [ "$doItNow" == "true" ] \
      && zfs destroy $snap
  done
  unset doItNow
}
