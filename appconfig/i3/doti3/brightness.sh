#!/bin/bash
# author: Matous Vrba

INCREMENT=10
MINIMAL=5

# set the minimal backlight value
light -c -S $MINIMAL

if [ $# -eq 0 ]; then
  echo Current brightness is: $(light -G)
  exit 0
elif [ $1 = "+" ]; then
  light -A $INCREMENT
elif [ $1 = "-" ]; then
  light -U $INCREMENT
else
  light -S $1
fi

# raw maximal brightness value
max_brightness=$(light -m -r -G)

# raw minimal brightness value
min_brightness=$(( $MINIMAL * $max_brightness / 100 ))

# get current raw brightness
current_brightness=$(light -r -G)

if [ $current_brightness -eq $max_brightness ]; then

  notify-send -u low -t 500 "Brightness on MAX" -h string:x-canonical-private-synchronous:anything -i display-brightness-low-symbolic

elif [ $current_brightness -le $min_brightness ]; then

  light -S $MINIMAL
  notify-send -u low -t 500 "Brightness on MIN" -h string:x-canonical-private-synchronous:anything -i display-brightness-low-symbolic

fi
