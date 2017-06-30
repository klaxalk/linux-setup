#!/bin/bash
# author: Tomas Baca

INCREMENT=10
MINIMAL=2

# find the id of my the touchpad
CURRENT_BRIGHTNESS=`xbacklight | sed -r "s/^(.*)\..*/\1/g"`

if [ $# -eq 0 ]; then

  echo "Current brightness is: $CURRENT_BRIGHTNESS"

else

  # increase brightness
  if [ "$1" = "+" ]; then

    xbacklight -inc "$INCREMENT"

    # decrease brightness
  elif [ "$1" = "-" ]; then

    if [[ $(( $CURRENT_BRIGHTNESS - $INCREMENT )) -lt $MINIMAL ]]; then

      xbacklight -set "$MINIMAL"

    else

      xbacklight -dec "$INCREMENT"

    fi

  else

    xbacklight -set "$1"

  fi

fi

CURRENT_BRIGHTNESS=`xbacklight | sed -r "s/^(.*)\..*/\1/g"`
if [ $CURRENT_BRIGHTNESS -le 100 ]; then

  notify-send -u low -i mouse "Brightness on MAX"

elif [ $CURRENT_BRIGHTNESS -le $MINIMAL ]; then

  notify-send -u low -i mouse "Brightness on MIN"

fi
