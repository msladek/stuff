#!/bin/bash

echo -e "\nSetup msmtp for root ..."
[ $EUID -ne 0 ] \
  && echo 'skipped, requires root' \
  && exit 1

echo -e "... install msmtp"
! command -v msmtp &> /dev/null \
  && ! aptitude install msmtp msmtp-mta \
  && echo "failed install" && exit 1

echo -e "... setup aliases"
echo "aliases /etc/aliases" | tee /etc/msmtprc >/dev/null
chmod 600 /etc/msmtprc
echo "TODO add mails to /etc/aliases"

echo -e "... setup user mailing"
## FIXME password is exposed to ps in sed command
[ ! -f ~/.msmtprc ] \
  && read -sp "Mailing password: " password && echo \
  && [ ! -z "$password" ] \
  && cp /opt/msladek/stuff/etc/msmtprc ~/.msmtprc \
  && chmod 600 ~/.msmtprc \
  && sed -i -e "s/<hostname>/$(hostname)/g" ~/.msmtprc \
  && sed -i -e "s/<password>/${password}/g" ~/.msmtprc \
  && -e "Subject: Test MSMTP\n\norigin: $(hostname)" | msmtp ${USER}@sladek.co \
  || echo 'unable to setup ~/.msmtprc'
unset password

exit 0
