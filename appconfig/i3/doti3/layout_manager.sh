#!/bin/bash

ACTION=$(echo "LOAD LAYOUT
SAVE LAYOUT
DELETE LAYOUT" | rofi -i -dmenu -p "Select action:")

if [[ "$ACTION" != "LOAD LAYOUT" ]] && [[ "$ACTION" != "SAVE LAYOUT" ]] && [[ "$ACTION" != "DELETE LAYOUT" ]]; then
  notify-send -u low -t 100 "Wrong choice!" -h string:x-canonical-private-synchronous:anything
  exit
fi

LAYOUT_NAMES=$(ls -a ~/ | grep "\.layout.*json" | sed -nr 's/\.layout-(.*)\.json/\1/p' | sed 's/\s/\n/g')
LAYOUT_NAME=$(echo "$LAYOUT_NAMES" | rofi -dmenu -p "Select layout")
LAYOUT_NAME=${LAYOUT_NAME^^}

if [ -z $LAYOUT_NAME ]; then
  exit
fi

WS_FILE=~/.layout-"$LAYOUT_NAME".json
CURRENT_WS=$(~/.i3/get_current_workspace.sh)

if [[ "$ACTION" = "LOAD LAYOUT" ]]; then

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

fi

if [[ "$ACTION" = "SAVE LAYOUT" ]]; then

  ALL_WS_FILE=~/.all-layouts.json

  echo "current is: $CURRENT_WS"

  rm "$WS_FILE"
  rm "$ALL_WS_FILE"

  CURRENT_MONITOR=$(xrandr | grep -w connected | awk '{print $1}')

  echo "current monitor: $CURRENT_MONITOR"

  i3-save-tree --output "$CURRENT_MONITOR" > "$ALL_WS_FILE" 2>&1
  i3-save-tree --workspace "$CURRENT_WS" > "$WS_FILE" 2>&1

  if [ -x "$(whereis nvim | awk '{print $2}')" ]; then
    VIM_BIN="$(whereis nvim | awk '{print $2}')"
    HEADLESS="--headless"
  elif [ -x "$(whereis vim | awk '{print $2}')" ]; then
    VIM_BIN="$(whereis vim | awk '{print $2}')"
    HEADLESS=""
  fi

  # remove comments
  $VIM_BIN $HEADLESS -E -s -c '%g/\/\//norm dd' -c "wqa" -- "$WS_FILE"
  $VIM_BIN $HEADLESS -E -s -c '%g/\/\//norm dd' -c "wqa" -- "$ALL_WS_FILE"

  # remove indents
  $VIM_BIN $HEADLESS -E -s -c '%g/^/norm 0d^' -c "wqa" -- "$WS_FILE"
  $VIM_BIN $HEADLESS -E -s -c '%g/^/norm 0d^' -c "wqa" -- "$ALL_WS_FILE"

  # remove commas
  $VIM_BIN $HEADLESS -E -s -c '%s/^},$/}/g' -c "wqa" -- "$WS_FILE"
  $VIM_BIN $HEADLESS -E -s -c '%s/^},$/}/g' -c "wqa" -- "$ALL_WS_FILE"

  # remove empty lines in
  $VIM_BIN $HEADLESS -E -s -c '%g/^$/norm dd' -c "wqa" -- "$WS_FILE"

  MATCH=0
  PATTERN_LINES=`cat $WS_FILE | wc -l`
  SOURCE_LINES=`cat $ALL_WS_FILE | wc -l`
  echo "pattern lines: $PATTERN_LINES"

  N_ITER=$(expr $SOURCE_LINES - $PATTERN_LINES)
  readarray pattern < $WS_FILE

  MATCH_LINE=0
  for (( a=1 ; $a-$N_ITER ; a=$a+1 )); do

    CURR_LINE=0
    MATCHED_LINES=0
    while read -r line1; do

      PATTERN_LINE=$(echo ${pattern[$CURR_LINE]} | tr -d '\n')

      if [[ "$line1" == "$PATTERN_LINE" ]]; then
        MATCHED_LINES=$(expr $MATCHED_LINES + 1)
      else
        break
      fi

      CURR_LINE=$(expr $CURR_LINE + 1)
    done <<< $(cat "$ALL_WS_FILE" | tail -n +"$a")

    if [[ "$MATCHED_LINES" == "$PATTERN_LINES" ]];
    then
      echo "matched on line $a"
      MATCH_LINE="$a"
      break
    fi
  done

  i3-save-tree --workspace "$CURRENT_WS" > "$WS_FILE" 2>&1

  $VIM_BIN $HEADLESS -E -s -c "normal ${MATCH_LINE}ggdGG{kdgg" -c "wqa" -- "$ALL_WS_FILE"
  $VIM_BIN $HEADLESS -E -s -c '%g/type/norm ^Wlciwcon' -c "wqa" -- "$ALL_WS_FILE"
  $VIM_BIN $HEADLESS -E -s -c '%g/fullscreen/norm ^Wr0' -c "wqa" -- "$ALL_WS_FILE"
  cat $ALL_WS_FILE | cat - $WS_FILE > /tmp/tmp.txt && mv /tmp/tmp.txt $WS_FILE
  $VIM_BIN $HEADLESS -E -s -c "normal Go]}" -c "wqa" -- "$WS_FILE"

  $VIM_BIN $HEADLESS -E -s -c '%g/instance/norm ^dW' -c "wqa" -- "$WS_FILE"
  # $VIM_BIN $HEADLESS -E -s -c '%g/class.*rviz/norm ^dW' -c "wqa" -- "$WS_FILE"
  $VIM_BIN $HEADLESS -E -s -c '%g/transient_for/norm ^dW' -c "wqa" -- "$WS_FILE"

  $VIM_BIN $HEADLESS -E -s -c '%g/\/\//norm dd' -c "wqa" -- "$WS_FILE"
  $VIM_BIN $HEADLESS -E -s -c '%g/^\\s\\+$/norm dd' -c "wqa" -- "$WS_FILE"
  $VIM_BIN $HEADLESS -E -s -c '%g/swallows/norm j^%k:s/,$//g' -c "wqa" -- "$WS_FILE"
  $VIM_BIN $HEADLESS -E -s -c '%g/^$/norm dd' -c "wqa" -- "$WS_FILE"
  $VIM_BIN $HEADLESS -E -s -c '%g/^$/norm gg=G' -c "wqa" -- "$WS_FILE"
  $VIM_BIN $HEADLESS -E -s -c '%s/}\n{/},{/g' -c "wqa" -- "$WS_FILE"

  notify-send -u low -t 2000 "Layout saved" -h string:x-canonical-private-synchronous:anything

fi

if [[ "$ACTION" = "DELETE LAYOUT" ]]; then

  rm "$WS_FILE"

fi
