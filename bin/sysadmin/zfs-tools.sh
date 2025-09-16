#!/bin/bash
[ "${BASH_SOURCE[0]}" = "${0}" ] \
  && echo "ERROR: this script is inteded to be sourced" \
  && exit 1
echo 'importing zfs-tools ...'

echo '... zfs-dataset-exists($dataset)'
function zfs-dataset-exists() {
  zfs list "$1" &> /dev/null
}

echo '... zfs-mountpoint-swap($dataset1 $dataset2)'
function zfs-mountpoint-swap() {
  ! zfs-dataset-exists "$1" && echo 'invalid fromDataset provided' && return 1
  ! zfs-dataset-exists "$2" && echo 'invalid toDataset provided' && return 1
  local mountpoint1=$(zfs get -H -o value mountpoint "$1")
  local mountpoint2=$(zfs get -H -o value mountpoint "$2")
  [ -n "$mountpoint1" ] \
    && sudo zfs set mountpoint="${mountpoint2:-none}" "$1" \
    && zfs list -H -o name,mountpoint "$1" \
    && sudo zfs set mountpoint="${mountpoint1:-none}" "$2" \
    && zfs list -H -o name,mountpoint "$2" \
    || { echo 'failed' && false; }
}

echo '... zfs-dataset-forEach($command [$postCommand])'
function zfs-dataset-forEach() {
  [ -z "$1" ] && echo 'no command provided' && return 1
  for dataset in $(zfs list -H -o name); do
    $1 $dataset "${@:2}"
  done
}

echo '... zfs-snaps-forEach($dataset $command [$postCommand])'
## for every snapshot chain: zfs-dataset-forEach zfs-snaps-forEach $command
function zfs-snaps-forEach() {
  ! zfs-dataset-exists "$1" && echo 'invalid dataset provided' && return 1
  [ -z "$2" ] && echo 'no command provided' && return 1
  for snap in $(zfs list -H -t snapshot -o name -s creation "$1"); do
    $2 $snap "${@:3}"
  done
}

echo '... zfs-snaps-first($dataset)'
function zfs-snaps-first() {
  ! zfs-dataset-exists "$1" && echo 'invalid dataset provided' && return 1
  local snap=$(zfs list -H -t snapshot -o name -s creation $1 | head -n1)
  echo "[$1] ${snap:-none}"
}

echo '... zfs-snaps-last($dataset)'
function zfs-snaps-last() {
  ! zfs-dataset-exists "$1" && echo 'invalid dataset provided' && return 1
  local snap=$(zfs list -H -t snapshot -o name -s creation $1 | tail -n1)
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
    local newname=$(echo $oldname | sed -E "$1")
    [ -n "$newname" ] && [ "$newname" != "$oldname" ] \
      && echo "$oldname -> $newname" \
      && [ "$doItNow" == "true" ] \
      && sudo zfs rename $oldname $newname
  done
  unset doItNow
}

echo '... zfs-snaps-compare($dataset1 $dataset2)'
function zfs-snaps-compare() {
  ! zfs-dataset-exists "$1" && echo 'invalid dataset provided' && return 1
  ! zfs-dataset-exists "$2" && echo 'invalid dataset provided' && return 1
  local snaps1=($(zfs list -H -t snapshot -o name -s creation "$1" | cut -d@ -f2))
  local snaps2=($(zfs list -H -t snapshot -o name -s creation "$2" | cut -d@ -f2))
  echo ${snaps1[@]} ${snaps2[@]} ${snaps2[@]} | tr ' ' '\n' | sort | uniq -u \
    | awk -v dataset="$1" '{print dataset"@"$1}'
  echo ${snaps1[@]} ${snaps1[@]} ${snaps2[@]} | tr ' ' '\n' | sort | uniq -u \
    | awk -v dataset="$2" '{print dataset"@"$1}'
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
      && sudo zfs destroy "$snap"
  done
  unset doItNow
}

echo '... zfs-load-keys()'
function zfs-load-keys() {
  for dataset in $(zfs get encryptionroot -H -o value -t filesystem | uniq); do
    zfs-dataset-exists "${dataset}" \
      && echo "${dataset}" \
      && sudo zfs load-key -r "${dataset}" \
      && sudo zfs mount "${dataset}"
  done
}
