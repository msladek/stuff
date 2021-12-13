#!/bin/bash
function replace() { sed "s|$1|$2|g"; }
function firstword() { awk '{print $1}'; }
function lastword() { awk 'NF{ print $NF }'; }
pass=''
askmsg="$1"

# $1 - "(<identifier>) Verification code: "
[[ "${1,,}" == *"verification code"* ]] \
  && identifier=$(echo "$1" | firstword | replace '[()]') \
  && [ ! -z "$identifier" ] \
  && askmsg="Enter PIN for '${identifier}': "

# $1 - "Enter passphrase for <path/to/keyfile>: "
[[ "${1,,}" == *"passphrase"* ]] \
  && command -v enpasscli+ >/dev/null \
  && [ ! -z "${enp_pin+x}" ] \
  && keyfile=$(echo "$1" | lastword | replace ':$' | xargs basename) \
  && [ ! -z "$keyfile" ] \
  && pass=$(enp_mode=noask enpasscli+ show "ssh $keyfile" 2>&1 \
    | grep 'pass :' \
    | lastword \
    | replace '"$' \
    | replace '\\\\' '\\')

[ -z $pass ] \
  && ssh-askpass "$askmsg" \
  || echo $pass
