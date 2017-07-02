#!/bin/bash
scr=$( xrandr -q | awk '/ connected/ {print $1}' )
scr="${scr//$'\n'/ }"
scrlst=($scr)
brt=$( xrandr --verbose | awk '/Brightness: / {print $2}')
brtls=($brt)
brt=${brtls[0]}
brt=$((0-${brt%.*}))
if [ "$brt" -eq 0 ]; then
  brt=1;
fi
if [ -z "$scr" ]; then
  i3-nagbar -m 'No screen defined' -t warning;
else
  for output in ${scr}; do
    xrandr --output $output --brightness $brt
  done;
fi
