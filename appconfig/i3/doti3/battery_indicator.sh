#!/bin/bash

batpc=$(cat /sys/class/power_supply/BAT0/capacity)

limit=20

if [[ "$batpc" < $limit ]]; then 
  echo "BATTERY EXHAUSTED"
  notify-send 'Battery low';
  exit 33
else
  echo ""
fi
