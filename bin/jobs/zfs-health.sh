#!/bin/bash

# status - check zpool display status for any anomalies.
COND1=$(/sbin/zpool status -x | grep -vFx 'all pools are healthy')
# online - check that all zpools are in ONLINE health state.
COND2=$(/sbin/zpool list -pH -o health | grep -vFx 'ONLINE')
# errors - check for READ, WRITE and CKSUM drive errors.
COND3=$(/sbin/zpool status | grep ONLINE | grep -vF 'state:' | awk '{print $3 $4 $5}' | grep -vFx '000')
# capacity - check if any zpools' capacity exeeds threshold 90%.
COND4=$(/sbin/zpool list -pH -o capacity | awk '$1 >= 90 {print}')

CONDITION="${COND1}${COND2}${COND3}${COND4}"
if [ "${CONDITION}" ]; then
  echo "ZFS health check FAILED: ${CONDITION} - $(/sbin/zpool status -x)"
  exit 1
else
  echo "ZFS health check passed: $(/sbin/zpool status -x)"
  exit 0
fi
