#!/bin/bash

# #{ killp()

# allows killing process with all its children
killp() {

  if [ $# -eq 0 ]; then
    echo "The command killp() needs an argument, but none was provided!"
    return
  else
    pes=$1
  fi

  for child in $(ps -o pid,ppid -ax | \
    awk "{ if ( \$2 == $pes ) { print \$1 }}")
    do
      # echo "Killing child process $child because ppid = $pes"
      killp $child
    done

# echo "killing $1"
kill -9 "$1" > /dev/null 2> /dev/null
}

# #}

# tmux split-window \; setw synchronize-panes on \; send-keys "sleep 1; pwd >> /tmp/tmux_restore_path.txt; tmux list-panes -s -F \"#{pane_pid} #{pane_current_command}\" | grep -v tmux | awk '{print \$1}' | while read in; do killp \$in; done" C-m exit C-m

pwd >> /tmp/tmux_restore_path.txt
tmux list-panes -s -F "#{pane_pid} #{pane_current_command}" | grep -v tmux | awk '{print $1}' | while read in; do killp $in; done
# tmux send-keys exit C-m
