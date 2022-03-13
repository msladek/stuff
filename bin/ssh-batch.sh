#!/bin/bash
ssh_cfg="${2:-$ssh_cfg}"
[ -z "$ssh_cfg" ] && read -ep "SSH config file: " ssh_cfg
for host in $(cat $ssh_cfg \
    | grep "^Host " \
    | tr --squeeze-repeats " " "\012" \
    | grep -vFx "Host" \
    | sort --unique); do
  echo && echo $host
  ssh -t $host "$1"
done
