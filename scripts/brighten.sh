#!/bin/sh

# Author: Petr Štibinger
# Use this to brighten the screen

currValue=$(light)
if [ $currValue = "100.00" ]; then
  notify-send -u low -t 1500 "Max brightness reached. Switch to LIGHT colorscheme for more contrast" -h string:x-canonical-private-synchronous:anything
else
  light -A 10
  notify-send -u low -t 400 "Brightness: $(light)" -h string:x-canonical-private-synchronous:anything
fi
