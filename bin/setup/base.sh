#!/bin/bash
setupDir="$(dirname "$(readlink -f "$0")")"
bash "$setupDir/installs.sh"
bash "$setupDir/bash.sh"
bash "$setupDir/ssh.sh"
bash "$setupDir/git.sh"
bash "$setupDir/sudo.sh"
echo -e "\n... base done!"
