#!/bin/bash

devices=()
folders=()

for folder in `ls /media/$USER`; do

  folders+=($(echo /media/$USER/$folder))
  devices+=($(findmnt -T "/media/$USER/$folder" | tail -n 1 | awk '{print $2}'))

done

# if [ -z $devices ]; then
#   exit 0
# fi

j=0

my_cmd=("tmux menu" "-x R" "-t 0" "-T Unmount")

for ((i=0; i < ${#devices[*]}; i++));
do

  name=$(echo "${folders[i]} [${devices[i]}]")
  my_cmd+=("'$name'")
  my_cmd+=("$j")
  mount_cmd=$(echo "if-shell -b \"udisksctl unmount -b ${devices[i]}\"" \"menu -x R -t 0 -T Success \"device_unmounted\" \"Esc\" \"none\"\" \"menu -x R -t 0 -T Error \"could_not_unmount_the_device\" \"Esc\" \"none\"\")
  my_cmd+=("'$mount_cmd'")

  j=$((j+1))

done

eval ${my_cmd[@]}

exit 0
