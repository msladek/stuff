#!/bin/bash

echo
read -p "Setup SSH agent service (Y/n)?" choice
case "$choice" in
  n|N ) ;;
  * ) mkdir -p ~/.config/systemd/user \
    && ln -sf ~/stuff/etc/systemd/ssh-agent.service ~/.config/systemd/user/ssh-agent.service \
    && systemctl --user daemon-reload \
    && systemctl --user enable --now ssh-agent \
    || echo "... skip, already setup";;
esac

echo -e "\nInstall Font Adobe Source Code Pro ..."
FONT_DIR="$HOME/.fonts/adobe-fonts/source-code-pro"
FONT_URL_ADOBE='https://github.com/adobe-fonts/source-code-pro.git'
git clone --depth 1 --branch release $FONT_URL_ADOBE $FONT_DIR \
	&& fc-cache -f -v $FONT_DIR \
  || echo "... skip, already setup"

echo -e "\nSetup enpasscli ..."
sudo ln -sf /opt/stuff/bin/enpasscli /usr/local/bin/enpasscli
sudo ln -sf /opt/stuff/bin/enpass-askpass.sh /usr/local/bin/enpass-askpass
mkdir -p ~/.bash.d && chmod 740 ~/.bash.d \
  && ln -sf ~/stuff/config/user/bash/enpass.sh ~/.bash.d/80-enpass.sh

exit 0
