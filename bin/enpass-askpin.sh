#!/bin/bash

# pin min length
[ -n "$enp_pin_length" ] || \
  enp_pin_length=6

# request pin if not already set (or empty +x)
while [ -z "${enp_pin+x}" ]; do
  read -s -p "Enter PIN (or omit): " enp_pin && echo 1>&2
  # validate pin min length
  [ -n "${enp_pin}" ] && [ ${#enp_pin} -lt $enp_pin_length ] \
    && unset enp_pin \
    && echo "PIN too short (>=${enp_pin_length})" 1>&2
done

echo $enp_pin
