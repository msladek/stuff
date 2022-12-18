#!/bin/bash
expectedIp="$1"
domain="o-o.myaddr.l.google.com"
for i in 4 3 2 1; do
  ns="ns${i}.google.com"
  actualIp=$(dig +short -4 TXT ${domain} @${ns} | sed 's/[^0-9.]//g')
  [ "$expectedIp" = "$actualIp" ] && exit 0
  sleep 1
done
echo >&2 "IP reassigned - \"${expectedIp}\" -> \"${actualIp}\""
exit 1
