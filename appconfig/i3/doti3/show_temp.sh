#!/bin/bash

OUTPUT=$(cat /sys/class/thermal/thermal_zone0/temp | cut -c1-2 -z; echo '°C') 
echo $OUTPUT

