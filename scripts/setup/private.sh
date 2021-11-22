#!/bin/bash

if [ ! -d ~/stuff/private ]; then
  echo
  read -p "Setup private repo? (y/N) " && [[ $REPLY =~ ^[Yy]$ ]] \
    && git clone https://github.com/msladek/stuffp.git ~/stuff/private
fi
[ -d ~/stuff/private ] \
  && chown -R $USER:$(id -gn) ~/stuff/private \
  && chmod -R go-rwx ~/stuff/private

