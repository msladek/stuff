#!/bin/bash

echo -e "\nSetup shell profile ..."
[ $EUID -eq 0 ] \
  && echo 'skipped, requires non-root' \
  && exit 1

[ ! -f ~/.profile ] && cp /etc/skel/.profile ~/
# let's setup our own ~/.profile.d
grep -qF -- ".profile.d" ~/.profile
if [ ! $? -eq 0 ]; then
cat <<"EOT" >> ~/.profile
if [ -d ~/.profile.d ]; then
  for f in ~/.profile.d/*.sh; do
    [ -r $f ] && source $f
  done
  unset f
fi
EOT
fi
# https://superuser.com/a/789499/1099716
rm -f ~/.bash_profile ~/.bash_login
rm -rf ~/.bash.d # remove legacy dir

echo -e "\nLink stuff directory ..."
[ ! -d /opt/stuff ] && echo "stuff not found" && exit 1
ln -sT /opt/stuff ~/stuff

echo -e "\nLink bash goodies ..."
if [ -e ~/.bash_aliases ] || [ -L ~/.bash_aliases ]; then
  echo && read -p "Remove legacy bash_aliases? (y/N) " && [[ $REPLY =~ ^[Yy]$ ]] \
    && rm -f ~/.bash_aliases
fi
mkdir -p ~/.profile.d && chmod 740 ~/.profile.d \
  && ln -sf /opt/stuff/etc/user/bash/env.sh       ~/.profile.d/10-env.sh \
  && ln -sf /opt/stuff/etc/user/bash/prompt.sh    ~/.profile.d/20-prompt.sh \
  && ln -sf /opt/stuff/etc/user/bash/aliases.sh   ~/.profile.d/50-aliases.sh \
  && ln -sf /opt/stuff/etc/user/bash/functions.sh ~/.profile.d/60-functions.sh \
  && ln -sf /opt/stuff/etc/user/bash/tmux.sh      ~/.profile.d/95-tmux.sh
ln -sf /opt/stuff/etc/user/vimrc ~/.vimrc
ln -sf /opt/stuff/etc/user/tmux.conf ~/.tmux.conf

echo -e "\nSetup eternal bash history ..."
# https://stackoverflow.com/a/19533853/1238689
sed -i '/HISTSIZE=/s/^[#[:space:]]*/#/g' ~/.bashrc
sed -i '/HISTFILESIZE=/s/^[#[:space:]]*/#/g' ~/.bashrc
[ -f ~/.bash_history ] \
  && cat ~/.bash_history >> ~/.bash_history_eternal \
  && rm ~/.bash_history

exit 0
