#!/bin/bash
if xinput list-props 10 | grep "Device Enabled (137):.1" >/dev/null
then
  xinput disable 10
  notify-send -u low -i mouse "Trackpad disabled"
else
  xinput enable 10
  notify-send -u low -i mouse "Trackpad enabled"
fi
