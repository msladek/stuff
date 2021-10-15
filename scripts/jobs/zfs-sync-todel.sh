#!/bin/bash

dataDir="/var/lib/zfs-sync"
lock="/var/lock/zfs-sync.lock"
logger="/var/log/zfs-sync.log"

touch $logger
log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $@" | tee -a $logger
}

execute() {
  printf -v cmd "$2" {@:3}
  [[ -z "$1" ]] && eval "$cmd" || ssh "$1" "$cmd"
}

## TODO
flagsDryRun=nv

cmdList="/sbin/zfs list -H -t snapshot -o name -s creation"
cmdSend="/sbin/zfs send -I %s %s"
cmdRecv="/sbin/zfs recv -Fu %s"

# TODO LOG

if [[ -f "$lock" ]]; then
  log "skipping, lock still set"
  exit 1
else
  log "starting"
  trap "rm $lock" EXIT
  touch $lock
  for file in ${dataDir}/*; do
    ## parse file name for sender data and content for receiver data
    ## filename:    [host:]sendpool\dataset
    ## filecontent: [host:]recvpool/dataset@last-received-snapshot
    filename=$(basename $file | sed 's/\\/\//')
    hostSend=""
    datasetSend="$filename"
    [[ $file =~ ":" ]] \
      && hostSend=$(echo $filename | cut -d ':' -f 1) \
      && datasetSend=$(echo $filename | cut -d ':' -f 2)
    filecontent=$(cat $file)
    hostRecv=""
    [[ $filecontent =~ ":" ]] \
      && hostRecv=$(echo $filecontent | cut -d ':' -f 1) \
      && filecontent=$(echo $filecontent | cut -d ':' -f 2)
    datasetRecv=$(echo $filecontent | cut -d '@' -f 1)
    snap1=$(echo $filecontent | cut -d '@' -f 2)

    # TODO ? VERIFY must be == 1
    # zfs list | grep $datasetSend | wc -l 
    # [[ $(zfs list | grep $datasetSend | wc -l) > 0 ]] && echo hi || echo ho

    # TODO use | grep @zfs-auto-snap ??   
    snap2=$(execute "$hostSend" "$cmdList" | grep $datasetSend | tail -n1 | cut -d '@' -f 2)
    
    log "${hostSend}:${datasetSend} -> ${hostRecv}:${datasetRecv} from @${snap1} to @${snap2}"
    # /sbin/zfs send -I ${datasetSend}@${snap1} ${datasetSend}@${snap2} | pv | ssh ${hostRecv} "/sbin/zfs recv -Fu ${datasetRecv}"
    [[ ! -z "$snap1" ]] && [[ ! -z "$snap2" ]] && [[ "$snap1" != "$snap2" ]] \
      && execute "$hostSend" "$cmdSend" "${datasetSend}@${snap1}" "${datasetSend}@${snap2}" \
       | execute "$hostRecv" "$cmdRecv" "${datasetRecv}" \
      && echo ${datasetRecv}@${snap2} > $file \
      || log "sending dataset failed"
  done
  log "done"
  exit 0
fi
