#!/bin/bash

OUTPUT=$(~/git/linux-setup/appconfig/i3/i3blocks/volume 5 pulse) 

echo $OUTPUT

if [ "$OUTPUT" != "MUTE" ]; then exit 33; fi
