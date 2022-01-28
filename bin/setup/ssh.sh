#!/bin/bash

echo -e "\nSetup SSH ..."

echo "... setup home directory"
sshDir=$HOME/.ssh
install -d -m 700 -o $USER -g $(id -gn) $sshDir

echo "... setup ssh config"
privDir=$HOME/stuff/private
if [ -d "$privDir" ]; then
  [ -L "${sshDir}/config" ] && rm -v "${sshDir}/config"
  [ -f ${sshDir}/config ] \
    && echo 'config already exists' \
    || cp ${privDir}/ssh/config ${sshDir}/config
  ln -sfn ${privDir}/ssh/config.d ${sshDir}/config.d
else
  echo "skipped, private repo missing"
fi

chmod -f 600 ${sshDir}/*
chmod -f 644 ${sshDir}/*.pub
chmod -f 700 ${sshDir}/config.d/
