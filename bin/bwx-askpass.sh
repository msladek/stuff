#!/bin/bash
function replace() { sed "s|$1|$2|g"; }
function firstword() { awk '{print $1}'; }
function lastword() { awk 'NF{ print $NF }'; }
pass=''
askmsg="$1"

# $1 - "(<identifier>) Verification code: "
if [[ "${1,,}" == *"verification code"* ]]; then
  identifier=$(echo "$1" | firstword | replace '[()]')
  askmsg="Enter OTP for '${identifier}': "
# $1 - "Enter passphrase for <path/to/keyfile>: "
elif [[ "${1,,}" == *"passphrase"* ]] && command -v bwx >/dev/null; then
  keyfile=$(echo "$1" | lastword | replace ':$' | xargs realpath | xargs basename)
  [ ! -z "$keyfile" ] \
    && echo "bwx-askpass - ${keyfile}" 1>&2 \
    && pass=$(bwx get password "ssh ${keyfile//_/ }") \
    || echo "bwx-askpass - ${keyfile} FAILED" 1>&2
fi

[ -z $pass ] \
  && ssh-askpass "$askmsg" 2>/dev/null \
  || echo $pass
