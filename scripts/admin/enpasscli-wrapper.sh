#!/bin/bash
## install:
## sudo ln -s .../enpasscli-wrapper.sh /usr/local/bin/enpasscli-wrapper

command -v enpasscli >/dev/null || exit 1

ssl_params="-aes-256-cbc -pbkdf2 -iter 1000000 -base64"
mpw_store=/tmp/enp_mpw

## request pin if not already set
[ -z "$ENP_PIN" ] \
  && read -s -p "Enter PIN: " ENP_PIN && echo

# load mpw from store if file and pin is available
[ -f "$mpw_store" ] && [ -n "$ENP_PIN" ] \
  && mpw=$(openssl enc -d $ssl_params -in $mpw_store -k $ENP_PIN)

# request mpw if missing and write it to the store if pin is available
[ -z "$mpw" ] \
  && read -s -p "Enter master password: " mpw && echo \
  && [ -n "$ENP_PIN" ] \
  && echo $mpw | openssl enc -e $ssl_params -out $mpw_store -k $ENP_PIN \
  && chmod 600 $mpw_store

# execute enpasscli with set mpw
[ -n "$mpw" ] \
  && export MASTERPW=$mpw \
  && enpasscli -vault=$HOME/.enpass-vault -keyfile=$HOME/.enpass-keyfile -sort "$@"
status_code=$?

# make sure the mpw doesn't leak
unset mpw
unset MASTERPW

exit $status_code
