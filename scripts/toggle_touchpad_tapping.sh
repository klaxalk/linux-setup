#!/bin/bash

if [[ -z $1 ]]; then
  # get by `xinput list`
  device="ASUE120A:00 04F3:327D Touchpad"
else
  device="$1"
fi

device_id=$(xinput list --id-only "$device")

state=$(xinput list-props $device_id | grep "Tapping Enabled (365)" | awk '{print $NF}')

if [[ $state == 1 ]]; then
  echo disabling touchpad tapping
  xinput set-prop "$device" "libinput Tapping Enabled" 0
else
  echo enabling touchpad tapping
  xinput set-prop "$device" "libinput Tapping Enabled" 1
fi
