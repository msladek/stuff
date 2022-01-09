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
  && command -v enpasscli >/dev/null \
  && [ ! -z "$PIN" ] \
  && keyfile=$(echo "$1" | lastword | replace ':$' | xargs basename) \
  && [ ! -z "$keyfile" ] \
  && enp_params="-nonInteractive -pin -vault=${enp_vault} -keyfile=${enp_keyfile}" \
  && pass=$(enpasscli ${enp_params} pass "ssh ${keyfile}")

[ -z $pass ] \
  && ssh-askpass "$askmsg" \
  || echo $pass
