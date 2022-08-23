#!/bin/bash

echo -e "\nSetup Git config ..."
[ $EUID -eq 0 ] \
  && echo 'skipped, requires non-root' \
  && exit 1

git config --global core.autocrlf input
git config --global core.editor vim
git config --global pull.rebase false
git config --global push.default current
[ -d /opt/msladek/stuff ] \
  && ! git config --get safe.directory | grep -qF "/opt/msladek/stuff" \
  && git config --global --add safe.directory "/opt/msladek/stuff"

if [ -f ~/.ssh/github ]; then
  git config --global core.sshCommand "ssh -i ~/.ssh/github -F /dev/null"
  git -C /opt/msladek/stuff remote set-url origin git@github.com:msladek/stuff.git > /dev/null 2>&1
  git -C /opt/msladek/stuffp remote set-url origin git@github.com:msladek/stuffp.git > /dev/null 2>&1
else
  git -C /opt/msladek/stuff remote set-url origin https://github.com/msladek/stuff.git > /dev/null 2>&1
  echo '~/.ssh/github not found'
fi
