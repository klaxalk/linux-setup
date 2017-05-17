#!/bin/bash
# author: Tomas Baca

INCREMENT=10
MINIMAL=10

# find the id of my the touchpad
CURRENT_VOLUME=`xbacklight | sed -r "s/^(.*)\..*/\1/g"`

if [ $# -eq 0 ]; then

  echo "Current brightness is: $CURRENT_VOLUME"

else

  # increase brightness
  if [ "$1" = "+" ]; then

    xbacklight -inc "$INCREMENT"

    # decrease brightness
  elif [ "$1" = "-" ]; then

    if [[ $(( $CURRENT_VOLUME - $INCREMENT )) -lt $MINIMAL ]]; then

      xbacklight -set "$MINIMAL"

    else

      xbacklight -dec "$INCREMENT"

    fi

  else

    xbacklight -set "$1"

  fi

fi

CURRENT_VOLUME=`xbacklight | sed -r "s/^(.*)\..*/\1/g"`
if [ $CURRENT_VOLUME -eq 100 ]; then

  notify-send -u low -i mouse "Brightness on MAX"

elif [ $CURRENT_VOLUME -eq $MINIMAL ]; then

  notify-send -u low -i mouse "Brightness on MIN"

fi

