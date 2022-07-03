#!/bin/bash

echo -e "\nSetup motd ..."
[ $EUID -ne 0 ] \
  && echo 'skipped, requires root' \
  && exit 1

## 50-neofetch
! command -v neofetch &> /dev/null \
  && ! aptitude install neofetch \
  && echo "failed install" && exit 1
neofetchConf=/opt/msladek/stuff/etc/neofetch.conf
[ -f $neofetchConf ] \
  && chown root $(dirname $neofetchConf) && chmod 1775 $(dirname $neofetchConf) \
  && chown root $neofetchConf && chmod 644 $neofetchConf \
  && cat > /etc/update-motd.d/50-neofetch <<endmsg
#!/bin/sh
neofetch --config $neofetchConf
endmsg

## 55-drivetemp
# https://unix.stackexchange.com/questions/558112
modinfo drivetemp > /dev/null \
  && modprobe drivetemp \
  && echo drivetemp > /etc/modules-load.d/drivetemp.conf \
  && cat > /etc/update-motd.d/55-drivetemp <<'endmsg'
#!/bin/sh
for f in /sys/class/scsi_disk/*/device/model; do
  [ -d "${f%/*}/hwmon" ] && \
    printf "%s (%-.2s°C)\n" "$(cat ${f%})" "$(cat ${f%/*}/hwmon/hwmon*/temp1_input)";
done
echo
endmsg

## 60-zpool
command -v zpool > /dev/null \
  && [ $(zpool list -H | wc -l) -gt 0 ] \
  && cat > /etc/update-motd.d/60-zpool <<'endmsg'
#!/bin/sh
echo "zfs status: $(zpool status -x)\n"
endmsg

## 80-last
command -v last > /dev/null \
  && cat > /etc/update-motd.d/80-last <<'endmsg'
#!/bin/sh
last --time-format=iso $USER \
  | grep 'pts' | egrep -v "tmux|:S" \
  | head -n2 | tail -n1 \
  | awk {'print "Last login: " $4 " from " $3'}
endmsg

chmod +x /etc/update-motd.d/*
truncate -s 0 /etc/motd

exit 0
