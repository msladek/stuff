#!/bin/bash
setupDir="$( cd "$( dirname "$0" )" && pwd )"

bash "$setupDir/installs.sh"
bash "$setupDir/bash.sh"
bash "$setupDir/private.sh"
bash "$setupDir/ssh.sh"
bash "$setupDir/git.sh"

echo
read -p "Setup firmware? (y/N) " choice
case "$choice" in
 y|Y ) bash "$setupDir/firmware.sh";;
esac

echo
read -p "Setup firewall? (y/N) " choice
case "$choice" in
 y|Y ) bash "$setupDir/firewall.sh";;
esac

echo
read -p "Setup mailing? (y/N) " choice
case "$choice" in
 y|Y ) bash "$setupDir/mail.sh";;
esac

echo
read -p "Setup jobs? (y/N) " choice
case "$choice" in
 y|Y ) bash "$setupDir/jobs.sh";;
esac

echo
read -p "Setup dynamic motd? (y/N) " choice
case "$choice" in
 y|Y ) bash "$setupDir/motd.sh";;
esac

echo
read -p "Setup desktop (y/N)?" choice
case "$choice" in
  y|Y ) bash "$setupDir/desktop.sh";;
esac

echo
read -p "Setup XFCE (y/N)?" choice
case "$choice" in
  y|Y ) . "$setupDir/xfce.sh";;
esac

echo -e "\n... done!"
