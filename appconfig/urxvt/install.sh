#!/bin/bash

# get the path to this script
APP_PATH=`dirname "$0"`
APP_PATH=`( cd "$APP_PATH" && pwd )`

unattended=0
subinstall_params=""
for param in "$@"
do
  echo $param
  if [ $param="--unattended" ]; then
    echo "installing in unattended mode"
    unattended=1
    subinstall_params="--unattended"
  fi
done

default=y
while true; do
  if [[ "$unattended" == "1" ]]
  then
    resp=$default
  else
    [[ -t 0 ]] && { read -t 5 -n 2 -p $'\e[1;32mInstall urxvt? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    # install urvxt
    sudo apt -y install rxvt-unicode-256color
    if [ "$?" != "0" ]; then echo "Press Enter to continues.."; read; fi

    # link the configuration
    cp $APP_PATH/dotXresources ~/.Xresources

    var1="18.04"
    var2=`lsb_release -r | awk '{ print $2 }'`
    if [ "$var2" = "$var1" ]; then
      export BEAVER=1
    fi

    EXTENSION_PATH="/usr/lib/urxvt/perl"

    if [ -n "$BEAVER" ]; then
      EXTENSION_PATH="/usr/lib/x86_64-linux-gnu/urxvt/perl"
    fi

    # link extensions
    for file in `ls $APP_PATH/extensions/`; do
      sudo ln -fs $APP_PATH/extensions/$file $EXTENSION_PATH/$file
    done

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
