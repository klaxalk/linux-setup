#!/bin/sh

# Author: Petr Štibinger
# Use this to brighten the screen

currValue=$(light)
if [ $currValue = "5.00" ]; then
  notify-send -u low -t 1500 "Min brightness reached. Switch to DARK colorscheme for less intensive lighting" -h string:x-canonical-private-synchronous:anything
else
  light -U 10
  notify-send -u low -t 400 "Brightness: $(light)" -h string:x-canonical-private-synchronous:anything
fi
