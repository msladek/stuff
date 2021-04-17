#!/bin/bash
echo -e "Setup msmtp for root ..."
command -v msmtp &> /dev/null \
  || sudo aptitude install msmtp msmtp-mta \
  || (echo "failed install" && exit 1)
read -sp "Mailing password: " password; echo
[[ ! -z "$password" ]] \
  && sudo cp ~/config/user/msmtprc /root/.msmtprc \
  && sudo sed -i -e "s/<hostname>/$(hostname)/g" /root/.msmtprc \
  && sudo sed -i -e "s/<password>/${password}/g" /root/.msmtprc \
  && sudo chmod 600 /root/.msmtprc \
  && echo -e "Subject: Test MSMTP\n\norigin: $(hostname)" | sudo msmtp root@sladek.co \
  || echo "Unable to setup msmtprc config"
unset password
