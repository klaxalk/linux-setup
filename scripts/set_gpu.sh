#!/bin/bash
GPU=$( echo "Intel
Nvidia" | rofi -dmenu -p "Select desired GPU:")

if [ "$GPU" != "Intel" ] && [ "$GPU" != "Nvidia" ]; then
  notify-send -u low -t 10000 "Wrong choice!" -h string:x-canonical-private-synchronous:anything
  exit
fi

if [ "$GPU" == "Intel" ]; then
  notify-send -u low -t 10000 "Switching to Intel GPU. Please wait until finished..." -h string:x-canonical-private-synchronous:anything
  sudo prime-select intel
  notify-send -u low -t 10000 "Using Intel GPU" -h string:x-canonical-private-synchronous:anything
elif [ "$GPU" == "Nvidia" ]; then
  notify-send -u low -t 10000 "Switching to Nvidia GPU. Please wait until finished..." -h string:x-canonical-private-synchronous:anything
  sudo prime-select nvidia
  notify-send -u low -t 10000 "Using Nvidia GPU" -h string:x-canonical-private-synchronous:anything
fi
