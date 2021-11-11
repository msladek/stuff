#!/bin/bash
## install:
## sudo ln -s .../enpasscli+.sh /usr/local/bin/enpasscli+

## make sure enpasscli is available in the path
command -v enpasscli >/dev/null || exit 1

## set parameters
mpw_store=/tmp/enp_mpw_$USER
mpw_prefix="ZJEeAYXuvjIFV3Obn9xy"
pbkdf2_iter="100000" ## iteration count for pbkdf2 key derivation function
ssl_params="-aes-256-cbc -pbkdf2 -iter $pbkdf2_iter -salt -base64"

## request pin if enabled and not already set
[ -z "$ENP_PIN" ] \
  && read -s -p "Enter PIN (or omit): " ENP_PIN && echo

# load mpw from store if file and pin is available
[ -f "$mpw_store" ] && [ -n "$ENP_PIN" ] \
  && decrypted=$(openssl enc -d $ssl_params -in $mpw_store -k $ENP_PIN 2>/dev/null | tr -d '\0') \
  && prefix=$(echo $decrypted | cut -d ':' -f 1) \
  && [ "$prefix" = "$mpw_prefix" ] \
  && mpw=$(echo $decrypted | cut -d ':' -f 2)

[ -n "$decrypted" ] && [ -z "$mpw" ] \
  && echo "oops, PIN is wrong"

# request mpw if missing and write it to the store if pin is enabled and available
[ -z "$mpw" ] \
  && read -s -p "Enter master password: " mpw && echo

# execute enpasscli with set mpw
[ -n "$mpw" ] \
  && export MASTERPW=$mpw \
  && enpasscli -vault=$HOME/.enpass-vault -keyfile=$HOME/.enpass-keyfile -sort "$@"
status_code=$?

[ $status_code ] && [ -n "$ENP_PIN" ] \
  && touch $mpw_store && chmod 600 $mpw_store \
  && echo "${mpw_prefix}:${mpw}" | openssl enc -e $ssl_params -out $mpw_store -k $ENP_PIN

[ ! $status_code ] && rm -f $mpw_store

# make sure the mpw doesn't leak
unset decrypted
unset mpw
unset MASTERPW

exit $status_code
