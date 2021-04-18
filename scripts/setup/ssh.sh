#!/bin/bash

echo -e "\nSetup SSH ..."
mkdir -p ~/.ssh
if [ -d ~/stuff/private ]; then
  ln -s ~/stuff/private/ssh/config ~/.ssh/config
  ln -s ~/stuff/private/ssh/keys/github ~/.ssh/github
else
  echo "skipped, private repo missing"
fi
chown $USER:$(id -gn) ~/.ssh
chmod -f 700 ~/.ssh
chmod -f 600 ~/.ssh/*
chmod -f 644 ~/.ssh/*.pub
