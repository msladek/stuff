#!/bin/bash
command -v zpool &> /dev/null && hasZFS=true || hasZFS=false
echo -e "Setup neofetch ..."
command -v neofetch &> /dev/null \
  || sudo aptitude install neofetch \
  || (echo "failed install" && exit 1)
sudo truncate -s 0 /etc/motd
echo -e '#!/bin/sh\nneofetch --config ~/stuff/config/system/neofetch.conf' \
  | sudo tee /etc/update-motd.d/50-neofetch > /dev/null
if $hasZFS; then
  echo -e '#!/bin/sh\necho "zfs status: $(zpool status -x)"' \
    | sudo tee /etc/update-motd.d/60-zpool > /dev/null
fi
# TODO use drivetemp https://unix.stackexchange.com/questions/558112/standard-way-to-check-the-hard-drive-temperature-without-installing-additional-p
sudo chmod +x /etc/update-motd.d/*
