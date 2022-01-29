#!/bin/bash
setupDir="$(dirname "$(readlink -f "$0")")"
taskDir=$setupDir/tasks

sudo bash "$taskDir/installs.sh"
     bash "$taskDir/bash.sh"
     bash "$taskDir/private.sh"
     bash "$taskDir/ssh.sh"
     bash "$taskDir/git.sh"
     bash "$taskDir/git-msladek.sh"
sudo bash "$taskDir/sudo.sh"
sudo bash "$taskDir/firmware.sh"
sudo bash "$taskDir/firewall.sh"
sudo bash "$taskDir/mail.sh"
sudo bash "$taskDir/sshd.sh"
sudo bash "$taskDir/jobs.sh"
sudo bash "$taskDir/smart.sh"
sudo bash "$taskDir/motd.sh"

echo -e "\n... done!"
