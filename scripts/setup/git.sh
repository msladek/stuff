#!/bin/bash

echo -e "\nSetup Git config ..."
git config --global core.editor "vim"
git config --global pull.rebase false
if [ -f ~/.ssh/github ]; then
  git config --global core.sshCommand "ssh -i ~/.ssh/github -F /dev/null"
  [ -d ~/stuff/private ] && cd ~/stuff/private \
    && git remote set-url origin git@github.com:msladek/stuffp.git  
  [ -d ~/stuff ] && cd ~/stuff \
    && git remote set-url origin git@github.com:msladek/stuff.git
fi
