#!/bin/bash

echo -e "\nSetup SSH ..."

echo "... setup home directory"
SSH_DIR=$HOME/.ssh
install -d -m 700 -o $USER -g $(id -gn) $SSH_DIR

echo "... setup ssh private"
PRIV_DIR=$HOME/stuff/private
if [ -d $PRIV_DIR ]; then
  ln -sfn $PRIV_DIR/ssh/config.d $SSH_DIR/config.d
  ln -s $PRIV_DIR/ssh/config $SSH_DIR/config \
    && read -p "Edit ssh config now ? (y/N) " && [[ $REPLY =~ ^[Yy]$ ]] \
    && vim $SSH_DIR/config
else
  echo "skipped, private repo missing"
fi

chmod -f 600 $SSH_DIR/*
chmod -f 644 $SSH_DIR/*.pub
chmod -f 700 $SSH_DIR/config.d/
