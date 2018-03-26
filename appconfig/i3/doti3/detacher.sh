#!/bin/bash

SESSION_NAME="D$RANDOM"

TMUX= /usr/local/bin/tmux new-session -s $SESSION_NAME -d

PARAMS="$*"

/usr/local/bin/tmux send-keys -t $SESSION_NAME:0 "$PARAMSexit"
