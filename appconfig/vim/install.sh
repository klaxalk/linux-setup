#!/bin/bash

# get the path to this script
APP_PATH=`dirname "$0"`
APP_PATH=`( cd "$APP_PATH" && pwd )`

read -r -p $'\033[31mApply VIM settings? [y/n] \033[00m' response

response=${response,,} # tolower
if [[ $response =~ ^(yes|y| ) ]]; then

  toilet Setting up vim

  # symlink vim settings
  rm ~/.vimrc
  rm ~/.vim
  ln -s $APP_PATH/dotvimrc ~/.vimrc
  ln -s $APP_PATH/dotvim ~/.vim

fi
