#!/bin/bash

# get the path to this script
APP_PATH=`dirname "$0"`
APP_PATH=`( cd "$APP_PATH" && pwd )`

default=y
while true; do
  [[ -t 0 ]] && { read -t 5 -n 2 -p $'\e[1;32mInstall urxvt? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    # install urvxt
    sudo apt-get -y install rxvt-unicode-256color

    # link the configuration
    cp $APP_PATH/dotXresources ~/.Xresources

    # link extensions
    for file in `ls $APP_PATH/extensions/`
do
    sudo ln -fs $APP_PATH/extensions/$file /usr/lib/urxvt/perl/$file
done

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
