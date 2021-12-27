#!/bin/bash
ssh_cfg="${1:-$ssh_cfg}"
[ -z "$ssh_cfg" ] && read -ep "SSH config file: " ssh_cfg
r="^Host "
for host in $(cat $ssh_cfg | grep $r | sed "s/${r}//g"); do
  echo && echo $host
  ssh -t $host "$1"
done
