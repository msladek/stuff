#!/bin/bash
setupDir="$(dirname "$(readlink -f "$0")")"
taskDir=$setupDir/tasks

bash "$taskDir/profile.sh"
bash "$taskDir/ssh.sh"
bash "$taskDir/git.sh"

echo -e "\n... done!"
