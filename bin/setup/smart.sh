#!/bin/bash
echo -e "Setup smart monitoring ..."
# S/../.././02 = Short test daily at 02:00
# L/../01/./03 = Long test first day each month at 03:00
echo -e 'DEVICESCAN -a -o on -S on -n standby,q -s (S/../.././02|L/../01/./03) -W 5,45,50 -m root@sladek.co' \
  | sudo tee /etc/smartd.conf > /dev/null
echo -e 'start_smartd=yes\nsmartd_opts="--interval=1800"\n' \
  | sudo tee /etc/default/smartmontools > /dev/null
sudo service smartd restart
