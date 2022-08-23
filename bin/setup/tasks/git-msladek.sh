#!/bin/bash

echo -e "Setup Git config for msladek ..."
[ "$USER" != 'msladek' ] && [ "$USER" != 'morrow' ] \
  && echo 'skipped, requires correct user' \
  && exit 1

git config --global user.name "Marc Sladek"
git config --global user.email "marc@sladek.dev"

githubSign=~/.ssh/github_sign
[ -f "$githubSign" ] && [ -f "${githubSign}.pub" ] \
  && git config --global gpg.format ssh \
  && git config --global user.signingkey "$(cat "${githubSign}.pub")" \
  && git config --global commit.gpgsign true \
  && git config --global tag.gpgsign true \
  || echo "WARNING: ssh key not found at ${githubSign}, please retry with priv/pub keys inplace."

exit 0
