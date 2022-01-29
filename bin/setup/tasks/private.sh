#!/bin/bash

echo -e "\nSetup stuffp ..."
[ $EUID -eq 0 ] \
  && echo 'skipped, requires non-root' \
  && exit 1

stuffpDir=/opt/msladek/stuffp
if [ ! -d $stuffpDir ]; then
  echo
  read -p "Clone stuffp repo? (y/N) " && [[ $REPLY =~ ^[Yy]$ ]] \
    && git clone git@github.com:msladek/stuffp.git $stuffpDir
fi
[ -d $stuffpDir ] \
  && chown -R $USER:$(id -gn) $stuffpDir \
  && chmod -R go-rwx $stuffpDir \
  && ln -sT $stuffpDir ~/stuffp

# fix symlinked stuffp dir
[ -L $stuffpDir ] \
  && echo '... fixing stuffp dir' \
  && oldStuffpDir=$(readlink $stuffpDir) \
  && rm -v $stuffpDir \
  && mv "$oldStuffpDir" $stuffpDir
