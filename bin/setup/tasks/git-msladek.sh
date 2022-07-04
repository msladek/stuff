#!/bin/bash

echo -e "Setup Git config for msladek ..."
[ "$USER" != 'msladek' ] && [ "$USER" != 'morrow' ] \
  && echo 'skipped, requires correct user' \
  && exit 1

git config --global user.name "Marc Sladek"
git config --global user.email "marc@sladek.dev"
githubGPG=~/.ssh/github_gpg
[ -f "$githubGPG" ] \
  && gpg --import "${githubGPG}.pub" \
  && gpg --import "$githubGPG" \
  && git config --global user.signingkey 8C64BE4EC6D00407 \
  && git config --global commit.gpgsign true \
  || echo "WARNING: gpg keys not found at ${githubGPG}, please retry with priv/pub keys inplace."

exit 0
