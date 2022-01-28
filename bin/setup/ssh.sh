#!/bin/bash

echo -e "\nSetup SSH ..."

echo "... setup home directory"
sshDir=$HOME/.ssh
install -d -m 700 -o $USER -g $(id -gn) $sshDir

echo "... setup ssh config"
privDir=$HOME/stuff/private
if [ -d "$privDir" ]; then
  ## cleanup
  [ -L "${sshDir}/config" ] && rm -v "${sshDir}/config"
  [ -L "${sshDir}/config.d" ] && rm -v "${sshDir}/config.d"
  [ -f ${sshDir}/config ] \
    && echo 'config already exists' \
    || cp ${privDir}/etc/user/ssh/config ${sshDir}/config
  mkdir -p ${sshDir}/config.d \
    && ln -sf ${privDir}/etc/user/ssh/config.d/* ${sshDir}/config.d/
else
  echo "skipped, private repo missing"
fi

chmod -f 600 ${sshDir}/*
chmod -f 644 ${sshDir}/*.pub
chmod -f 700 ${sshDir}/config.d/
