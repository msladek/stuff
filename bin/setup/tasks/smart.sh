#!/bin/bash

echo -e "\nSetup S.M.A.R.T. monitoring ..."
[ $EUID -ne 0 ] \
  && echo 'skipped, requires root' \
  && exit 1

! command -v smartctl >/dev/null \
  && echo "... install smartmontools" \
  && ! apt install smartmontools \
  && echo "failed install" && exit 1

# S/../.././02 = Short test daily at 02:00
# L/../01/./03 = Long test first day each month at 03:00
! grep -q -- '^DEVICESCAN ' /etc/smartd.conf \
  && echo "... activate device scan" \
  && echo -e 'DEVICESCAN -a -o on -S on -n standby,q -s (S/../.././02|L/../01/./03) -W 5,45,50 -m root@sladek.co' \
   | tee /etc/smartd.conf > /dev/null
echo -e 'start_smartd=yes\nsmartd_opts="--interval=1800"\n' \
  | tee /etc/default/smartmontools > /dev/null
service smartd restart

exit 0
