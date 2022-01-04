#!/bin/bash
## install:
## sudo ln -s .../enpasscli+.sh /usr/local/bin/enpasscli+
## ln -s .../key.enpasskey ~/.enpasscli/keyfile
## ln -s ~/Documents/Enpass/Vaults/primary/ ~/.enpasscli/vault

! command -v enpasscli >/dev/null \
  && echo "enpasscli not available" 1>&2 \
  && exit 1

enp_vault=${enp_vault:-$HOME/.enpasscli/vault}
[ ! -r "$enp_vault" ] \
  && echo "vault \"${enp_vault}\" not readable " 1>&2 \
  && exit 1
enp_keyfile=${enp_keyfile:-$HOME/.enpasscli/keyfile}
[ ! -r "$enp_keyfile" ] \
  && echo "keyfile \"${enp_keyfile}\" not readable " 1>&2 \
  && exit 1

# path to the mpw store file
mpw_store=${mpw_store:-${XDG_RUNTIME_DIR:-/tmp}/enp.mpw}
# use stdin to ask for credentials
enp_mode=${enp_mode:-ask}
# iteration count for pbkdf2 key derivation function
pbkdf2_iter=${pbkdf2_iter:-100000}
# enpasscli param list
enp_params=${enp_params:--vault=${enp_vault} -keyfile=${enp_keyfile} -sort}
# openssl enc param list
ssl_params=${ssl_params:--aes-256-cbc -pbkdf2 -iter $pbkdf2_iter -salt -base64}

if [ "$1" = "rm" ]; then
  rm -f $mpw_store
  echo "store cleaned" 1>&2
  exit 0
fi

# ask for pin
[ "$enp_mode" = 'ask' ] \
  && command -v enpass-askpin >/dev/null \
  && enp_pin="$(enpass-askpin)"
pin_challenge=$(echo $enp_pin | sha256sum | head -c 50)

# try loading mpw from store if file and pin is available
if [ -f "$mpw_store" ] && [ -n "$enp_pin" ]; then
  decrypted=$(openssl enc -d $ssl_params -in $mpw_store -k $enp_pin 2>/dev/null | tr -d '\0')
  challenge=$(echo $decrypted | cut -d ':' -f 1)
  if [ "$pin_challenge" = "$challenge" ]; then
    mpw=$(echo $decrypted | cut -d ':' -f 2)
  else
    echo "oops, PIN is wrong" 1>&2
    exit 1
  fi
fi

# request mpw if missing
[ -z "$mpw" ] \
  && [ "$enp_mode" = 'ask' ] \
  && read -s -p "Enter master password: " mpw && echo \
  && mpw_typed=true

# execute enpasscli with set mpw and write it to the store if unlock was successful and pin is available
if [ -n "$mpw" ]; then
  MASTERPW=$mpw enpasscli $enp_params "$@"
  exit_code=$?
  [ $exit_code -lt 2 ] && [ "$mpw_typed" = true ] && [ -n "$enp_pin" ] \
    && touch $mpw_store && chmod 600 $mpw_store \
    && echo "${pin_challenge}:${mpw}" | openssl enc -e $ssl_params -out $mpw_store -k $enp_pin
  [ $exit_code -gt 1 ] \
    && echo "oops, wrong master password" 1>&2
  fi
  exit $exit_code
fi

exit 1
