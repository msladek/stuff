#!/bin/bash

if [ ! -d ~/stuff/private ]; then
  echo
  read -p "Setup private repo? (y/N) " choice
  case "$choice" in
   y|Y ) git clone https://github.com/msladek/stuffp.git ~/stuff/private;;
  esac
fi
[ -d ~/stuff/private ] \
  && chown -R $USER:$(id -gn) ~/stuff/private \
  && chmod -R go-rwx ~/stuff/private
