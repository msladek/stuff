#!/bin/bash
setupDir="$( cd "$( dirname "$0" )" && pwd )"
bash "$setupDir/installs.sh"
bash "$setupDir/bash.sh"
bash "$setupDir/ssh.sh"
bash "$setupDir/git.sh"
echo -e "\n... done!"
