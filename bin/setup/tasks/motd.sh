#!/bin/bash

echo -e "\nSetup motd ..."
[ $EUID -ne 0 ] \
  && echo 'skipped, requires root' \
  && exit 1

! command -v neofetch &> /dev/null \
  && ! aptitude install neofetch \
  && echo "failed install" && exit 1
neofetchConf=/opt/msladek/stuff/etc/neofetch.conf
truncate -s 0 /etc/motd
[ -f $neofetchConf ] \
  && chown root $(dirname $neofetchConf) && chmod 1775 $(dirname $neofetchConf) \
  && chown root $neofetchConf && chmod 644 $neofetchConf \
  && echo -e "#!/bin/sh\nneofetch --config $neofetchConf" \
   | tee /etc/update-motd.d/50-neofetch > /dev/null
if command -v zpool > /dev/null && [ $(zpool list -H | wc -l) -gt 0 ]; then
  echo -e '#!/bin/sh\necho "zfs status: $(zpool status -x)"' \
    | tee /etc/update-motd.d/60-zpool > /dev/null
fi
# TODO use drivetemp https://unix.stackexchange.com/questions/558112/standard-way-to-check-the-hard-drive-temperature-without-installing-additional-p
chmod +x /etc/update-motd.d/*

exit 0
