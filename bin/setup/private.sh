#!/bin/bash

if [ ! -d /opt/stuff/private ]; then
  echo
  read -p "Setup private repo? (y/N) " && [[ $REPLY =~ ^[Yy]$ ]] \
    && git clone git@github.com:msladek/stuffp.git /opt/stuff/private
fi
[ -d /opt/stuff/private ] \
  && chown -R $USER:$(id -gn) /opt/stuff/private \
  && chmod -R go-rwx /opt/stuff/private
