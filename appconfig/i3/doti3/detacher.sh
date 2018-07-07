#!/bin/bash

TMUX_PATH="/usr/local/bin/tmux"

SESSION_NAME="D$RANDOM"

TMUX= /usr/local/bin/tmux new-session -s $SESSION_NAME -d

if [[ "$1" == "1" ]]; then

  shift
  PARAMS="$*"
  OUT_FILE="/tmp/$SESSION_NAME.txt"
  rm "$OUT_FILE" > /dev/null 2>&1

  $TMUX_PATH send-keys -t $SESSION_NAME:0 "{ $PARAMS } > $OUT_FILEexit"

  while true; do

    EXISTING_SESSION=`$TMUX_PATH ls 2> /dev/null | grep "$SESSION_NAME" | wc -l`

    if [ "$EXISTING_SESSION" -eq "0" ]; then
      cat "$OUT_FILE"
      rm "$OUT_FILE"
      break
    fi
    sleep 0.2
  done

else

  PARAMS="$*"

  $TMUX_PATH send-keys -t $SESSION_NAME:0 "$PARAMSexit"

fi
