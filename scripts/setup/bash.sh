#!/bin/bash

echo -e "\nSetup bashrc ..."
# let's setup our own ~/.bash.d
grep -qF -- ".bash.d" ~/.bashrc
if [ ! $? -eq 0 ]; then
cat <<"EOT" >> ~/.bashrc

if [ -d ~/.bash.d ]; then
  for f in ~/.bash.d/*.sh; do
    [ -r $f ] && source $f
  done
  unset f
fi

EOT
fi
# https://superuser.com/a/789499/1099716
[ -f ~/.bash_profile ] && [ -f ~/.profile ] \
  && echo && read -p "Remove .bash_profile in favour of .profile? (y/N) " && [[ $REPLY =~ ^[Yy]$ ]] \
  && rm -f ~/.bash_profile

echo -e "\nLink stuff directory ..."
[ ! -d ~/stuff ] && echo "stuff not found" && exit 1
sudo chown -R $USER:$(id -gn) ~/stuff
sudo ln -sfn ~/stuff /opt/stuff
sudo ln -sfn /opt/stuff /root/stuff

echo -e "\nLink bash goodies ..."
if [ -e ~/.bash_aliases ] || [ -h ~/.bash_aliases ]; then
  echo && read -p "Remove legacy bash_aliases? (y/N) " && [[ $REPLY =~ ^[Yy]$ ]] \
    && rm -f ~/.bash_aliases
fi
mkdir -p ~/.bash.d && chmod 740 ~/.bash.d \
  && ln -sf ~/stuff/config/user/bash/env.sh       ~/.bash.d/10-env.sh \
  && ln -sf ~/stuff/config/user/bash/prompt.sh    ~/.bash.d/20-prompt.sh \
  && ln -sf ~/stuff/config/user/bash/aliases.sh   ~/.bash.d/50-aliases.sh \
  && ln -sf ~/stuff/config/user/bash/functions.sh ~/.bash.d/60-functions.sh \
  && ln -sf ~/stuff/config/user/bash/tmux.sh      ~/.bash.d/95-tmux.sh
ln -sf ~/stuff/config/user/vimrc ~/.vimrc
ln -sf ~/stuff/config/user/tmux.conf ~/.tmux.conf

echo -e "\nSetup eternal bash history ..."
# https://stackoverflow.com/a/19533853/1238689
sed -i '/HISTSIZE=/s/^[#[:space:]]*/#/g' ~/.bashrc
sed -i '/HISTFILESIZE=/s/^[#[:space:]]*/#/g' ~/.bashrc
[ -f ~/.bash_history ] \
  && cat ~/.bash_history >> ~/.bash_history_eternal \
  && rm ~/.bash_history

echo -e "\nEnable sudo insults ..."
echo -e 'Defaults insults' | sudo tee /etc/sudoers.d/insults > /dev/null
sudo chmod o-rwx /etc/sudoers.d/insults

echo -e "\nEnable doas ..."
echo -e "permit persist $USER as root" | sudo tee /etc/doas.conf > /dev/null
sudo chmod o-rwx /etc/doas.conf
