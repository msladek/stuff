#!/bin/bash

echo -e "\nSetup msmtp for root ..."
[ $EUID -ne 0 ] \
  && echo 'skipped, requires root' \
  && exit 1

! command -v msmtp &> /dev/null \
  && echo "... install msmtp" \
  && ! aptitude install msmtp msmtp-mta \
  && echo "failed install" && exit 1

## TODO password is exposed to ps in sed command
## -> password to keyring instead of plaintex in file
if [ ! -f ~/.msmtprc ]; then
  echo -e "... setup user mailing"
  read -sp "Mailing password: " password && echo
  [ ! -z "$password" ] \
    && install -T -m 600 -o $USER -g $(id -gn) /opt/msladek/stuff/etc/msmtprc ~/.msmtprc
    && sed -i -e "s/<hostname>/$(hostname)/g" ~/.msmtprc \
    && sed -i -e "s/<password>/${password}/g" ~/.msmtprc \
    || echo 'unable to setup ~/.msmtprc'
fi
unset password

[ -f ~/.msmtprc ] \
  && ! grep -qF -- "aliases" ~/.msmtprc \
  && echo -e "... setup aliases" \
  && echo -e "\naliases /etc/aliases" >> ~/.msmtprc \
  && vim /etc/aliases

[ -f ~/.msmtprc ] \
    && echo -e "Subject: Test MSMTP\n\norigin: $(hostname)" | sendmail root

exit 0
