#!/bin/bash

LAYOUT_NAMES=$(ls -a ~/ | grep "\.layout.*json" | sed -nr 's/\.layout-(.*)\.json/\1/p' | sed 's/\s/\n/g')
LAYOUT_NAME=$(echo "$LAYOUT_NAMES" | rofi -dmenu -p "Select layout to load")
LAYOUT_NAME=${LAYOUT_NAME^^}

if [ -z $LAYOUT_NAME ]; then
  exit
fi

# ITER=0
# LAYOUR_NAMES_2=""
# while read -r line; do
#   LAYOUT_NAMES[$ITER]=$(echo "$line" | sed -nr 's/\.layout-(.*)\.json/\1/p')
#   ITER=$(expr $ITER + 1)
# done <<< "$LAYOUT_NAMES"

CURRENT_WS=$(~/.i3/get_current_workspace.sh)
WS_FILE=~/.layout-"$LAYOUT_NAME".json

WINDOWS=$(~/.i3/workspace_list_windows.sh)

for window in $WINDOWS; do
  xdotool windowunmap $window
done

# sleep 0.3

# i3-msg "focus parent, focus parent, kill"

i3-msg "append_layout $WS_FILE"

for window in $WINDOWS; do

  # sleep 0.3

  xdotool windowmap $window
done
