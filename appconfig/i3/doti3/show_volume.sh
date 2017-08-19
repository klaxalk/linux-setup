#!/bin/bash
# author: Viktor Walter
# is supposed to switch between two keyboard layouts

# CURRENT_LAYOUT=$(setxkbmap -query | awk '/layout/{print $2}') 

# echo $CURRENT_LAYOUT | sed 's/.*/\U&/'

OUTPUT=$(~/git/linux-setup/appconfig/i3/i3blocks/volume 5 pulse) 

echo $OUTPUT

if [ "$OUTPUT" != "MUTE" ]; then exit 33; fi
