#!/bin/bash
if [ `prime-select query` = "intel" ]; then
  sudo rm /lib/modprobe.d/blacklist-nvidia.conf
  sudo modprobe nvidia
fi
