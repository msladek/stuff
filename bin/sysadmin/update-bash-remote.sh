#!/bin/bash

ssh_cfg=~/.ssh/config
r="^Host "

for host in $(cat $ssh_cfg | egrep $r | sed "s/${r}//g" | grep -v 'github'); do
  echo && echo $host
  ssh $host "git clone https://github.com/msladek/stuff.git /opt/msladek/stuff >/dev/null 2>&1 || git -C /opt/msladek/stuff pull"
  success=$?
  if [ $success -eq 0 ]; then
    ssh -t $host "bash /opt/msladek/stuff/bin/setup/base.sh"
  elif [ $success -gt 0 ]; then
    echo "failed to update $host"
  fi
done
