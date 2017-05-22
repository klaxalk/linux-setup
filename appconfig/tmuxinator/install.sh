#!/bin/bash

# get the path to this script
APP_PATH=`dirname "$0"`
APP_PATH=`( cd "$APP_PATH" && pwd )`

while true; do
  [[ -t 0 ]] && { read -t 10 -n 2 -p $'\033[31mInstall TMUXINATOR? [y/n] \033[00m' resp || resp="y" ; }
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    toilet Installing tmuxinator

    # install tmuxinator
    cd $APP_PATH/../../submodules/tmuxinator
    git pull
    sudo gem install tmuxinator

    # symlink tmuxinator settings
    rm ~/.tmuxinator
    ln -s $APP_PATH/dottmuxinator ~/.tmuxinator

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
