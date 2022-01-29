#!/bin/bash
setupDir="$(dirname "$(readlink -f "$0")")"
taskDir=$setupDir/tasks

bash "$taskDir/installs.sh"
bash "$taskDir/bash.sh"
bash "$taskDir/private.sh"
bash "$taskDir/ssh.sh"
bash "$taskDir/git.sh"
bash "$taskDir/sudo.sh"

echo
read -p "Setup firmware? (y/N) " && [[ $REPLY =~ ^[Yy]$ ]] \
 && bash "$taskDir/firmware.sh"

echo
read -p "Setup firewall? (y/N) " && [[ $REPLY =~ ^[Yy]$ ]] \
 && bash "$taskDir/firewall.sh"

echo
read -p "Setup mailing? (y/N) " && [[ $REPLY =~ ^[Yy]$ ]] \
 && bash "$taskDir/mail.sh"

echo
read -p "Setup SSH Server? (y/N) " && [[ $REPLY =~ ^[Yy]$ ]] \
 && bash "$taskDir/sshd.sh"

echo
read -p "Setup jobs? (y/N) " && [[ $REPLY =~ ^[Yy]$ ]] \
 && bash "$taskDir/jobs.sh"

echo
read -p "Setup S.M.A.R.T.? (y/N) " && [[ $REPLY =~ ^[Yy]$ ]] \
 && bash "$taskDir/smart.sh"

echo
read -p "Setup dynamic motd? (y/N) " && [[ $REPLY =~ ^[Yy]$ ]] \
 && bash "$taskDir/motd.sh"

echo
read -p "Setup desktop (y/N)? "
if [[ $REPLY =~ ^[Yy]$ ]]; then
  bash "$taskDir/desktop-installs.sh"
  bash "$taskDir/desktop-setup.sh"
  bash "$taskDir/git-msladek.sh"
  read -p "Setup XFCE (y/N)?" && [[ $REPLY =~ ^[Yy]$ ]] \
    && bash "$taskDir/desktop-xfce.sh"
fi

echo -e "\n... all done!"
