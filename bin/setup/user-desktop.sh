#!/bin/bash
setupDir="$(dirname "$(readlink -f "$0")")"
taskDir=$setupDir/tasks

bash "$taskDir/bash.sh"
bash "$taskDir/private.sh"
bash "$taskDir/ssh.sh"
bash "$taskDir/git.sh"
bash "$taskDir/git-msladek.sh"
bash "$taskDir/desktop-setup.sh"

echo -e "\n... done!"
