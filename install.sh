#!/bin/bash

sudo usermod -a -G dialout $USER

# get the path to this script
MY_PATH=`dirname "$0"`
MY_PATH=`( cd "$MY_PATH" && pwd )`

# define paths
APPCONFIG_PATH=$MY_PATH/appconfig

# install packages
# vim sl ranger git cmake ccmake
sudo apt-get install vim ranger sl git indicator-multiload figlet toilet gem ruby build-essential

# make git folder in home
mkdir ~/git

# download, compile and install tmux
bash $APPCONFIG_PATH/tmux/install.sh

# compile and install tmuxinator
bash $APPCONFIG_PATH/tmuxinator/install.sh

# copy vim settings
bash $APPCONFIG_PATH/vim/install.sh

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
