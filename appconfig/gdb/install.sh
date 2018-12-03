#!/bin/bash

# get the path to this script
APP_PATH=`dirname "$0"`
APP_PATH=`( cd "$APP_PATH" && pwd )`

default=y
while true; do
  [[ -t 0 ]] && { read -t 5 -n 2 -p $'\e[1;32mInstall helper debugging tools? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    # install gdb and python3-pil for gdb-imshow
    sudo apt install gdb python3-pil
    # link the configuration and mods
    mkdir -p ~/.gdb
    ln -sf $APP_PATH/gdb_modules/gdb-imshow ~/.gdb
    ln -sf $APP_PATH/gdb_modules/eigen ~/.gdb
    cp -f $APP_PATH/dotgdbinit ~/.gdbinit
    # copy the script for debugging roslaunched programs
    sudo ln -sf $APP_PATH/debug_roslaunch /usr/bin/debug_roslaunch

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
