#!/bin/bash
# author: Pavel Petracek
# Screen brightness control script using "brightnessctl"
# Installation: `apt install brightnessctl`

INCREMENT="10%"
MINIMAL=1
MAXIMAL=$(brightnessctl max)

# get original raw brightness value
orig_brightness=$(brightnessctl get)

if [ $# -eq 0 ]; then
  echo Current brightness is: $orig_brightness
  exit 0
fi

if [[ $1 == "+"  || $1 == "-" ]]; then
  brightnessctl set $INCREMENT$1 > /dev/null

  new_brightness=$(brightnessctl get)
  if [ $new_brightness -le $MINIMAL ]; then

    notify-send -u low -t 500 "Brightness on MIN" -h string:x-canonical-private-synchronous:anything -i display-brightness-low-symbolic

  elif [ $new_brightness -eq $MAXIMAL ]; then

    notify-send -u low -t 500 "Brightness on MAX" -h string:x-canonical-private-synchronous:anything -i display-brightness-low-symbolic

  fi

fi
