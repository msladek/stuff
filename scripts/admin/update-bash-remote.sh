#!/bin/bash

source $HOME/.bash_aliases

ssh_cfg=/opt/scripts/desktop/ssh_config
r="^Host "

for host in $(cat $ssh_cfg | egrep $r | sed "s/${r}//g" | grep -v 'github'); do
  echo $host
  ssh $host "cd /opt/scripts > /dev/null 2>&1 && git pull"
  success=$?
  if [ $success -eq 1 ]; then
    command ssh $host "cat > ~/.bash_aliases" < ~/.bash_aliases
  elif [ $success -gt 1 ]; then
    echo "failed to update $host"
  fi
done
