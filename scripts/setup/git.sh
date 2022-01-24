#!/bin/bash

echo -e "\nSetup Git config ..."
git config --global core.editor "vim"
git config --global pull.rebase false
git config --global push.default current

[ ! -f ~/.ssh/github ] \
  && echo "generating new ~/.ssh/github" \
  && ssh-keygen -t ed25519 -a 100 -C "${HOSTNAME}@sladek.co" -f ~/.ssh/github
if [ -f ~/.ssh/github ]; then
  git config --global core.sshCommand "ssh -i ~/.ssh/github -F /dev/null"
  cd ~/stuff/private > /dev/null 2>&1 \
    && git remote set-url origin git@github.com:msladek/stuffp.git  
  cd ~/stuff > /dev/null 2>&1 \
    && git remote set-url origin git@github.com:msladek/stuff.git
fi
