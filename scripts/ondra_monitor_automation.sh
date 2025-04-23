#!/bin/bash

export DISPLAY=:0
export XAUTHORITY=/home/prochazo/.Xauthority
# echo "Display is $DISPLAY"
xrandr_output=$(xrandr -display :0 --prop)
active_monitors=$(xrandr -display :0 --listactivemonitors)
office_edid="10ac20a14c373630"
office_off="xrandr --output eDP-1 --primary --mode 1920x1200 --pos 0x0 --rotate normal --output DP-1 --off --output HDMI-1 --off --output DP-2 --off --output DP-3 --off --output DP-4 --off"
office_on="xrandr --output eDP-1 --primary --mode 1920x1200 --pos 0x0 --rotate normal --output DP-1 --off --output HDMI-1 --off --output DP-2 --off --output DP-3 --mode 2560x1440 --pos 1920x0 --rotate normal --output DP-4 --off"

if [[ $xrandr_output =~ $office_edid ]]
then
    echo "Office Monitor is connected"
    if [[ $active_monitors =~ "DP-3" ]]
    then
        echo "Office Monitor already active, doing nothing"
    else
        echo "Office Monitor not active, activating"
        $office_on
    fi
else
    echo "Office Monitor is not connected"
    if [[ $active_monitors =~ "DP" ]]
    then
        echo "Office monitor active, switching off"
        $office_off
    else
        echo "Office monitor inactive, doing nothing"
    fi
fi
