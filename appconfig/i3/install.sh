#!/bin/bash

# get the path to this script
APP_PATH=`dirname "$0"`
APP_PATH=`( cd "$APP_PATH" && pwd )`

read -r -p $'\033[31mInstall i3? [y/n] \033[00m' response

response=${response,,} # tolower
if [[ $response =~ ^(yes|y|| ) ]]; then

  toilet installing i3

  # install i3
  sudo apt-get install i3

  # for brightness and volume control
  sudo apt-get update; sudo apt-get install xbacklight alsa-utils pulseaudio
  
  # symlink tmuxinator settings
  rm ~/.i3
  ln -s $APP_PATH/doti3 ~/.i3

  # put $USE_I3 into bashrc

  num=`cat ~/.bashrc | grep "USE_I3" | wc -l`
  if [ "$num" -lt "1" ]; then

    echo "
# do you use i3?
export USE_I3=true" >> ~/.bashrc

  fi
  
fi
