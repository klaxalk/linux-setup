#!/bin/bash
#
coords=$( xwininfo -id $(xdotool getactivewindow) | awk '/Absolute/ {print $4}' )
coords="${coords//$'\n'/ }"
coordlst=($coords)
xdotool mousemove ${coordlst[0]} ${coordlst[1]}
