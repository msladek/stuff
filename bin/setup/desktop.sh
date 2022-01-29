#!/bin/bash
setupDir="$(dirname "$(readlink -f "$0")")"
taskDir=$setupDir/tasks

sudo bash "$taskDir/installs.sh"
     bash "$taskDir/profile.sh"
     bash "$taskDir/private.sh"
     bash "$taskDir/ssh.sh"
     bash "$taskDir/git.sh"
     bash "$taskDir/git-msladek.sh"
sudo bash "$taskDir/sudo.sh"
sudo bash "$taskDir/firmware.sh"
sudo bash "$taskDir/firewall.sh"
sudo bash "$taskDir/jobs.sh"
sudo bash "$taskDir/motd.sh"
sudo bash "$taskDir/desktop-installs.sh"
     bash "$taskDir/desktop-setup.sh"
# sudo bash "$taskDir/desktop-xfce.sh"

echo -e "\n... done!"
