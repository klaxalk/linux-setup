#!/bin/bash

BAT_FILE=/sys/class/power_supply/BAT0/capacity

if [ ! -f $BAT_FILE ]; then
  echo ""
  exit 0
fi

batpc=$(cat $BAT_FILE)

limit=20

if [[ "$batpc" -lt "$limit" ]]; then
  echo "BATTERY EXHAUSTED"
  notify-send 'Battery low';
  exit 33
else
  echo ""
fi
