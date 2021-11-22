#!/bin/bash

echo -e "\nSetup bashrc ..."
grep -qF -- ".bashrc" ~/.bash_profile \
    || echo "\n[ -f ~/.bashrc ] && source ~/.bashrc" >> ~/.bash_profile
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

echo -e "\nLink stuff directory ..."
[ ! -d ~/stuff ] && echo "stuff not found" && exit 1
sudo chown -R $USER:$USER ~/stuff
sudo ln -sfn ~/stuff /opt/stuff
sudo ln -sfn /opt/stuff /root/stuff

echo -e "\nLink bash goodies ..."
mkdir -p ~/.bash.d
chmod 744 ~/.bash.d
ln -sf ~/stuff/config/user/bash/custom.sh ~/.bash.d/custom.sh && chmod u+x ~/.bash.d/custom.sh
if [ -e ~/.bash_aliases ] || [ -h ~/.bash_aliases ]; then
  echo && read -p "Remove legacy bash_aliases? (y/N) " && [[ $REPLY =~ ^[Yy]$ ]] \
    && rm -f ~/.bash_aliases
fi
ln -sf ~/stuff/config/user/vimrc ~/.vimrc
ln -sf ~/stuff/config/user/tmux.conf ~/.tmux.conf

echo -e "\nEnable sudo insults ..."
echo -e 'Defaults insults' | sudo tee /etc/sudoers.d/insults > /dev/null
