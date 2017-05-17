#!/bin/bash
if xinput list-props 13 | grep "Device Enabled (137):.1" >/dev/null
then
  xinput disable 13
  notify-send -u low -i mouse "Trackpad disabled"
else
  xinput enable 13
  notify-send -u low -i mouse "Trackpad enabled"
fi
