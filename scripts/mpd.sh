#!/bin/bash

# kill all scripts with same name except this one
 kill `pgrep "$(basename -- "$0")" | head -n -2`

while true; do
  old=$(mpc current)
  old_state=$(mpc | grep paused)
  sleep 2 
  new=$(mpc current)
  new_state=$(mpc | grep playing)
  echo "$old"
  echo "$new"
  
  if [[ "$old" != "$new" ]] ; then 
    notify-send -t 2000 "Now Playing" "$(mpc --format '%title% \n%artist% - %album%' current)"
  fi
  
  if [[ ! -z "$old_state" && ! -z "$new_state" ]]  ; then 
    notify-send -t 2000 "$(mpc --format '%title% \n%artist% - %album%' current)"
  fi
done
