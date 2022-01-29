#!/bin/bash
setupDir="$(dirname "$(readlink -f "$0")")"
taskDir=$setupDir/tasks

sudo bash "$taskDir/installs.sh"
     bash "$taskDir/bash.sh"
     bash "$taskDir/ssh.sh"
     bash "$taskDir/git.sh"
sudo bash "$taskDir/sudo.sh"

echo -e "\n... done!"
