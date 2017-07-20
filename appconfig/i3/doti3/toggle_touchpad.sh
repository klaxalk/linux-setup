#!/bin/bash
# author: Tomas Baca

# run "xinput" to get this id, e.g. from the line:
# ↳ DLL075B:01 06CB:76AF Touchpad             id=13   [slave  pointer  (2)]
DEVICE_ID="06CB:76AF"

# find the id of my the touchpad
DEVICE_NUMBER=`xinput | grep "$DEVICE_ID" | sed -r 's/.*id=([0-9]*).*/\1/g'`

echo $DEVICE_NUMBER

if xinput list-props "$DEVICE_NUMBER" | grep "Device Enabled (...):.1" >/dev/null
then

  xinput disable "$DEVICE_NUMBER"
  notify-send -u low -i mouse "Touchpad disabled"

  # banish mouse
  xdotool mousemove 10000 10000

else

  xinput enable "$DEVICE_NUMBER"
  notify-send -u low -i mouse "Touchpad enabled"

fi
