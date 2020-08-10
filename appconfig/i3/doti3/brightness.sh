#!/bin/bash
# author: Matous Vrba

INCREMENT=10
MINIMAL=5

# set the minimal backlight value
light -N $MINIMAL

# get original raw brightness value
orig_brightness=$(light -G -r)

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

# raw minimal brightness value
min_brightness=$(light -r -P)

# get new raw brightness after increment/decrement
new_brightness=$(light -r -G)

if [ $new_brightness -le $min_brightness ]; then

  light -S $MINIMAL
  notify-send -u low -t 500 "Brightness on MIN" -h string:x-canonical-private-synchronous:anything -i display-brightness-low-symbolic

elif [ $new_brightness -eq $orig_brightness ]; then

  notify-send -u low -t 500 "Brightness on MAX" -h string:x-canonical-private-synchronous:anything -i display-brightness-low-symbolic

fi
