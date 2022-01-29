#!/bin/bash

echo -e "Setup Git config for msladek ..."
[ "$USER" != 'msladek' ] && [ "$USER" != 'morrow' ] \
  && echo 'skipped, requires correct user' \
  && exit 1

git config --global user.name "Marc Sladek"
git config --global user.email "marc@sladek.me"
git config --global user.signingkey 8C64BE4EC6D00407
git config --global commit.gpgsign true
githubGPG=~/.ssh/github_gpg
[ -f "$githubGPG" ] \
  && gpg --import "${githubGPG}.pub" \
  && gpg --import "$githubGPG" \
  || echo "WARNING: no gpg keys found, please import manually."

exit 0
