#!/bin/bash

sudo usermod -a -G dialout $USER

# get the path to this script
MY_PATH=`dirname "$0"`
MY_PATH=`( cd "$MY_PATH" && pwd )`

# define paths
APPCONFIG_PATH=$MY_PATH/appconfig
SUBMODULES_PATH=$MY_PATH/submodules

# install packages
# vim sl ranger git cmake ccmake
sudo apt-get install vim ranger sl git indicator-multiload figlet toilet gem ruby

# make git folder in home
mkdir ~/git

# download, compile and install tmux
source $APPCONFIG_PATH/tmux/install.sh

# compile and install tmuxinator
source $APPCONFIG_PATH/tmuxinator/install.sh

# copy vim settings
source $APPCONFIG_PATH/vim/install.sh

# add sourcing of dotbashrd to .bashrc
num=`cat ~/.bashrc | grep "dotbashrc" | wc -l`
if [ "$num" -lt "1" ]; then

  echo "Adding source to .bashrc"
  # set bashrc
  echo "
  # sourcing tomas's tmux preparation
  source $MY_PATH/dotbashrc" >> ~/.bashrc

else

  echo "Reference in .bashrc is already there..."

fi

# source .bashrc
source ~/.bashrc
