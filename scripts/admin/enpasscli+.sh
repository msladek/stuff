#!/bin/bash
## install:
## sudo ln -s .../enpasscli+.sh /usr/local/bin/enpasscli+

# make sure enpasscli is available in the path
command -v enpasscli >/dev/null || exit 1

exit_code=0

# path to the mpw store file
[ -n "$mpw_store" ] || \
  mpw_store=/tmp/enp_mpw_$USER
# iteration count for pbkdf2 key derivation function
[ -n "$pbkdf2_iter" ] || \
  pbkdf2_iter="100000"
# ssl full openssl enc param list
[ -n "$ssl_params" ] || \
  ssl_params="-aes-256-cbc -pbkdf2 -iter $pbkdf2_iter -salt -base64"

# request pin if enabled and not already set
[ -z "$ENP_PIN" ] \
  && read -s -p "Enter PIN (or omit): " ENP_PIN && echo
pin_challenge=$(echo $ENP_PIN | sha224sum | head -c 50)

# try loading mpw from store if file and pin is available
if [ -f "$mpw_store" ] && [ -n "$ENP_PIN" ]; then
  decrypted=$(openssl enc -d $ssl_params -in $mpw_store -k $ENP_PIN 2>/dev/null | tr -d '\0')
  challenge=$(echo $decrypted | cut -d ':' -f 1)
  if [ "$pin_challenge" = "$challenge" ]; then
    mpw=$(echo $decrypted | cut -d ':' -f 2)
  else
    echo "oops, PIN is wrong"
    exit_code=2
  fi
fi

# request mpw if missing
[ -z "$mpw" ] && read -s -p "Enter master password: " mpw && echo

# execute enpasscli with set mpw and write it to the store if unlock was successful and pin is available

if [ -n "$mpw" ]; then
  export MASTERPW=$mpw
  enpasscli -vault=$HOME/.enpass-vault -keyfile=$HOME/.enpass-keyfile -sort "$@"
  exit_code=$? # BORKED: returned error code by enpasscli always 0
  [ $exit_code ] && [ -n "$ENP_PIN" ] \
    && touch $mpw_store && chmod 600 $mpw_store \
    && echo "${pin_challenge}:${mpw}" | openssl enc -e $ssl_params -out $mpw_store -k $ENP_PIN
fi

exit $exit_code
