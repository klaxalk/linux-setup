#!/bin/bash

# get the path to this script
APP_PATH=`dirname "$0"`
APP_PATH=`( cd "$APP_PATH" && pwd )`

read -r -p $'\033[31mInstall i3? [y/n] \033[00m' response

response=${response,,} # tolower
if [[ $response =~ ^(yes|y|| ) ]]; then

  toilet installing i3

  # install tmuxinator
  sudo apt-get install i3
  
  # symlink tmuxinator settings
  rm ~/.i3
  ln -s $APP_PATH/doti3 ~/.i3
  
fi
