#!/bin/bash

zfs="/sbin/zfs"


########################################################################
# Functions                                                            #
########################################################################

die() {
  echo >&2 "ERROR - $@"
  exit 1
}

sshx() {
  [[ -z "$1" ]] && eval "${@:2}" || ssh -q -o "BatchMode=yes" "$1" "${@:2}"
  return $?
}

snapList() {
  local host=$1
  local dataset=$2
  local nameParts=$3
  sshx "$host" $zfs list -H -t snapshot -o name -s creation \
    | grep "$dataset" \
    | egrep "$nameParts" \
    | cut -d '@' -f2;
  return ${PIPESTATUS[0]}
}


########################################################################
# Parse arguments                                                      #
########################################################################

doRun=true
snapshotNameParts=""
snap1=""
while getopts "dg:s:" option; do
  case $option in
    d) echo "dry run enabled"; doRun=false;;
    g) snapshotNameParts=$OPTARG;; ## e.g. "zfs-auto-snap_daily|zfs-auto-snap_weekly|zfs-auto-snap_monthly"
    s) snap1=$OPTARG;; ## start snapshot
    \?) die "invalid option";;
  esac
done
ARG1=${@:$OPTIND:1}
ARG2=${@:$OPTIND+1:1}
ARG3=${@:$OPTIND+2:1}

## parse ARG1 as send host/dataset
hostSend=""
datasetSend="$ARG1"
[[ $ARG1 =~ ":" ]] \
  && hostSend=$(echo $ARG1 | cut -d ':' -f1) \
  && datasetSend=$(echo $ARG1 | cut -d ':' -f2)

## parse ARG2 as receive host/dataset
hostRecv=""
datasetRecv="$ARG2"
[[ $ARG2 =~ ":" ]] \
  && hostRecv=$(echo $ARG2 | cut -d ':' -f1) \
  && datasetRecv=$(echo $ARG2 | cut -d ':' -f2)

## test datasets
[[ -n "$datasetSend" ]] \
  || die "source dataset required"
[[ -n "$datasetRecv" ]] \
  || die "target dataset required"
[[ "${hostSend}:${datasetSend}" != "${hostRecv}:${datasetRecv}" ]] \
  || die "cannot send within same dataset"


########################################################################
# Main                                                                 #
########################################################################

## get snapshot lists
snapListSend=$(snapList "$hostSend" "$datasetSend" "$snapshotNameParts")
[[ $? == 0 ]] || die "unable to connect to ${hostSend}"
snapListRecv=$(snapList "$hostRecv" "$datasetRecv" "$snapshotNameParts")
[[ $? == 0 ]] || die "unable to connect to ${hostRecv}"

## determine start snapshot
[[ -z "$snap1" ]] \
  && snap1="$ARG3"
[[ -z "$snap1" ]] \
  && snap1=$(echo "$snapListRecv" | tail -n1)
[[ -z "$snap1" ]] \
  && snap1=$(echo "$snapListSend" | head -n1)

## test if start snapshot exists on sender
[[ $(echo "$snapListSend" | grep "$snap1" | wc -l) > 0 ]] \
  || die "missing snapshot ${hostSend}:${datasetSend}@${snap1}"

## send initial snapshot if needed
if [[ $(echo "$snapListRecv" | grep "$snap1" | wc -l) == 0 ]]; then
  echo "send init ${hostSend}:${datasetSend}@${snap1} -> ${hostRecv}:${datasetRecv}"
  if [[ "$doRun" == true ]]; then
    sshx "$hostSend" $zfs send ${datasetSend}@${snap1} \
  | pv \
  | sshx "$hostRecv" $zfs recv -us $datasetRecv
    [[ ${PIPESTATUS[0]} != 0 || ${PIPESTATUS[2]} != 0 ]] \
      || die "init send required but failed"
  fi
## check first snapshot
elif [[ "$(echo "$snapListSend" | head -n1)" != $(echo "$snapListRecv" | head -n1) ]]; then
  echo "WARN first snapshot mismatch: ${hostSend}:${datasetSend} != ${hostRecv}:${datasetRecv}"
fi

## send all snapshots incrementally
snap2=$(echo "$snapListSend" | tail -n1)
if [[ "$snap1" != "$snap2" ]]; then
  echo "send incr ${hostSend}:${datasetSend}@[${snap1} TO ${snap2}] -> ${hostRecv}:${datasetRecv}"
  if [[ "$doRun" == true ]]; then
    sshx "$hostSend" $zfs send -I ${datasetSend}@${snap1} ${datasetSend}@${snap2} \
  | pv \
  | sshx "$hostRecv" $zfs recv -us $datasetRecv
    [[ ${PIPESTATUS[0]} != 0 || ${PIPESTATUS[2]} != 0 ]] \
      || die "ERROR incremental send failed"
  fi
else
  echo "nothing to do, latest snapshot: ${snap1}"
fi

echo "done"
exit 0
