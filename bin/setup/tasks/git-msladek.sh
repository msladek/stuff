#!/bin/bash

echo -e "Setup Git config for msladek ..."
[ "$USER" != 'msladek' ] && [ "$USER" != 'morrow' ] \
  && echo 'skipped, requires correct user' \
  && exit 1

git config --global user.name "Marc Sladek"
git config --global user.email "marc@sladek.dev"
gpgKey=8C64BE4EC6D00407

githubAuth=~/.ssh/github
githubAuthFile=~/.ssh/github_$(hostname)
[ ! -f $githubAuth ] \
  && echo "no auth key found, generating one..." \
  && ssh-keygen -t ed25519 -a 100 -f "${githubAuthFile}" -C "$(git config --get user.email)" \
  && ln -sf "${githubAuthFile}"     "${githubAuth}" \
  && ln -sf "${githubAuthFile}.pub" "${githubAuth}.pub" \
  && echo -e "\n[NOTE] add auth key to github: $(cat ${githubAuth}.pub)\n"

 gpg --list-secret-keys --with-colons --keyid-format=long | grep -qF ":${gpgKey}:" \
  && git config --global --unset gpg.format \
  && git config --global user.signingkey "$gpgKey" \
  && git config --global commit.gpgsign true \
  && git config --global tag.gpgsign true \
  || echo "ERROR: setup signing failed, GPG key not found: $gpgKey"

exit 0
