#!/bin/bash

echo -e "Setup Git config for msladek ..."
[ "$USER" != 'msladek' ] && [ "$USER" != 'morrow' ] \
  && echo 'skipped, requires correct user' \
  && exit 1

git config --global user.name "Marc Sladek"
git config --global user.email "marc@sladek.dev"

githubSign=~/.ssh/github_sign
[ ! -f $githubSign ] \
  && echo "no signing key found, generating one..." \
  && ssh-keygen -t ed25519 -a 100 -f "$githubSign" -C "$(git config --get user.email)" \
  && echo -e "add signing key to github:\n$(cat ${githubSign}.pub)"
[ -f "$githubSign" ] && [ -f "${githubSign}.pub" ] \
  && git config --global gpg.format ssh \
  && git config --global user.signingkey "$(cat ${githubSign}.pub)" \
  && git config --global commit.gpgsign true \
  && git config --global tag.gpgsign true \
  || echo "WARNING: setup signing failed"

exit 0
