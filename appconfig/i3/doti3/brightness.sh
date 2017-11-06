#!/bin/bash
# author: Tomas Baca
# ensure running as root

if [ "$(id -u)" != "0" ]; then
  exec sudo "$0" "$@" 
fi

INCREMENT=10
MINIMAL=2

basedir="/sys/class/backlight/"

# get the backlight handler
handler=$basedir$(ls $basedir)"/"

# find the id of my the touchpad
current_brightness_abs=$(cat $handler"brightness")

# get max brightness
max_brightness=$(cat $handler"max_brightness")

# get current brightness %
current_brightness_perc=$(( 100 * $current_brightness_abs / $max_brightness ))

if [ $# -eq 0 ]; then

  echo "Current brightness is: $current_brightness_perc"

else

  # increase brightness
  if [ "$1" = "+" ]; then

    new_brightness_p=$(( $current_brightness_perc + $INCREMENT ))
    new_brightness=$(( $max_brightness * $new_brightness_p / 100 ))

    # decrease brightness
  elif [ "$1" = "-" ]; then

    if [[ $(( $current_brightness_perc - $INCREMENT )) -lt $MINIMAL ]]; then

      new_brightness=$(( $max_brightness * $MINIMAL / 100 ))

    else

      new_brightness_p=$(( $current_brightness_perc - $INCREMENT ))
      new_brightness=$(( $max_brightness * $new_brightness_p / 100 ))

    fi

  else

    new_brightness=$(( $max_brightness * $1 / 100 ))

  fi

  # set the new brightness value
  chmod 666 $handler"brightness"
  echo $new_brightness > $handler"brightness"
  notify-send -u low -i mouse "Brightness $current_brightness_perc%"

fi

# get max brightness
max_brightness=$(cat $handler"max_brightness")

# get current brightness %
current_brightness_perc=$(( 100 * $current_brightness_abs / $max_brightness ))

if [ $current_brightness_perc -ge 100 ]; then

  notify-send -u low -i mouse "Brightness on MAX"

elif [ $current_brightness_perc -le $MINIMAL ]; then

  notify-send -u low -i mouse "Brightness on MIN"

fi
