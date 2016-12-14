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
  rm -rf ~/.vim
  ln -s $APP_PATH/dotvimrc ~/.vimrc
  ln -s $APP_PATH/dotvim ~/.vim

  # add variable for ctags sources into .bashrc
  num=`cat ~/.bashrc | grep "CTAGS_SOURCE_DIR" | wc -l`
  if [ "$num" -lt "1" ]; then
  
    echo "Adding CTAGS_SOURCE_DIR variable to .bashrc"
    # set bashrc
    echo '
# where should ctags look for sourcs to parse?
# -R dir1 -R dir2 ...
export CTAGS_SOURCE_DIR="-R ~/ros_workspace"' >> ~/.bashrc
 
  fi

  # check whether ~/.my.vimrc file exists, copy mine version if does not 
  if [ ! -f ~/.my.vimrc ]; then
    echo "Creating ~/.my.vimrc file"
      
    cp $APP_PATH/dotmy.vimrc ~/.my.vimrc

  fi
  
  vim -E +PluginInstall +qall

fi
