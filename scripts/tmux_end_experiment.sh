#!/bin/bash

tmux list-windows -F '#{window_name}' | grep rosbag$ > /dev/null
ret=$?

# killall_cmd="split-window ; setw synchronize-panes on ; send-keys 'sleep 1; pwd >> /tmp/tmux_restore_path.txt; tmux list-panes -s -F \\\"##{pane_pid} ##{pane_current_command}\\\" | grep -v tmux | awk \\'{print \\\$1}\\' | while read in; do killp \\\$in; done' C-m"
stop_rosbag_cmd="send-keys -t rosbag C-c"
rename_rosbag_cmd='command-prompt -p "Enter the desired rosbag folder suffix: " "run \"~/git/linux-setup/scripts/rename_rosbag_latest.sh '%%'\""'
killall_cmd="run-shell '~/git/linux-setup/scripts/tmux_killall.sh'"

tgt_window="-t 'rosbag'"
option1="'Stop rosbag & rename' r '$stop_rosbag_cmd ; $rename_rosbag_cmd'"
option2="'Stop rosbag & end   ' e '$stop_rosbag_cmd ; $killall_cmd'"
option3="'Stop rosbag         ' s '$stop_rosbag_cmd'"
option4="'End experiment now  ' k '$killall_cmd'"
hline="''"
cancel="'Cancel              ' Esc ''"

my_cmd=("tmux menu" "-y S" "-T 'End experiment?'")

if [ $ret -eq 0 ]; then
  my_cmd+=( $tgt_window )
  my_cmd+=( $title )
  my_cmd+=( $option1 )
  my_cmd+=( $option2 )
  my_cmd+=( $option3 )
  my_cmd+=( $option4 )
  my_cmd+=( $hline )
  my_cmd+=( $cancel )
else
  tmux display-message "Didn't find 'rosbag' window!"
  my_cmd+=( $title )
  my_cmd+=( $option4 )
  my_cmd+=( $hline )
  my_cmd+=( $cancel )
fi

# echo ${my_cmd[@]}
eval ${my_cmd[@]}
