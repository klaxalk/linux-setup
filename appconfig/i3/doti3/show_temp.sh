#!/bin/bash

if [ -z $1 ]; then
  THERMAL_ZONE=0
else
  THERMAL_ZONE=$1
fi

OUTPUT=$(cat /sys/class/thermal/thermal_zone"$THERMAL_ZONE"/temp | cut -c1-2; echo '°C') 
if [[ "$OUTPUT" == "°C" ]]; then
  OUTPUT="N/A"
fi

echo $OUTPUT

