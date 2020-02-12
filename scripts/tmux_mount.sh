#!/bin/bash

drives=($( lsblk | awk '{print match($1, /[^ ]/) ? $1 : "none"}' ))
spaces=($( lsblk | awk '{print match($4, /[^ ]/) ? $4 : "none"}' ))
types=($( lsblk | awk '{print match($6, /[^ ]/) ? $6 : "none"}' ))
mounts=($( lsblk | awk '{print match($7, /[^ ]/) ? $7 : "none"}' ))

j=0

my_cmd=("tmux menu" "-x R" "-t 0" "-T Mount")

for ((i=0; i < ${#drives[*]}; i++));
do

  if [ "${mounts[i]}" == "none" ]; then


    if [ "${types[i]}" == "disk" ]; then
      my_cmd+=("${drives[i]}")
      my_cmd+=('\"\"')
      my_cmd+=('\"\"')
    else
      my_cmd+=(\"${drives[i]} ${spaces[i]}\")
      my_cmd+=("$j")
      mount_cmd=$(echo "if-shell -b \"udisksctl mount -b /dev/${drives[i]:2}\"" \"new-window\; send-keys cd_media\" \"menu -x R -t 0 -T Error \"could_not_mount_the_device\" \"Esc\" \"none\"\")
      my_cmd+=("'$mount_cmd'")
    fi
    j=$((j+1))
  fi
done
# echo ${my_cmd[@]}
eval ${my_cmd[@]}
