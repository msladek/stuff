#!/bin/bash

source $HOME/.bash_aliases

ssh_cfg=~/.ssh/config
r="^Host "

for host in $(cat $ssh_cfg | egrep $r | sed "s/${r}//g" | grep -v 'github'); do
  echo && echo $host
  command ssh $host "git clone https://github.com/msladek/stuff.git > /dev/null 2>&1 || (cd ~/stuff && git pull)"
  success=$?
  if [ $success -eq 0 ]; then
    command ssh -t $host "bash ~/stuff/scripts/setup/base.sh"
  elif [ $success -gt 0 ]; then
    echo "failed to update $host"
  fi
done
