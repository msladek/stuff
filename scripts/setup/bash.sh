#!/bin/bash

[ ! -d ~/stuff ] && echo "stuff not found" && exit 1
sudo chown -R $USER:$USER ~/stuff
echo -e "\nLink bash goodies ..."
ln -sf ~/stuff/config/user/bash_aliases ~/.bash_aliases
grep -qF -- ".bash_aliases" ~/.bashrc \
    || echo "source ~/.bash_aliases" >> ~/.bashrc
grep -qF -- ".bashrc" ~/.bash_profile \
    || echo "source ~/.bashrc" >> ~/.bash_profile
ln -sf ~/stuff/config/user/vimrc ~/.vimrc
ln -sf ~/stuff/config/user/tmux.conf ~/.tmux.conf

echo -e "\nEnable sudo insults ..."
echo -e 'Defaults insults' | sudo tee /etc/sudoers.d/insults > /dev/null
