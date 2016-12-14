#!/bin/bash

sudo usermod -a -G dialout $USER

# get the path to this script
MY_PATH=`dirname "$0"`
MY_PATH=`( cd "$MY_PATH" && pwd )`

# define paths
APPCONFIG_PATH=$MY_PATH/appconfig

# install packages
# vim sl ranger git cmake ccmake
sudo apt-get install vim ranger sl htop git indicator-multiload figlet toilet gem ruby build-essential tree

# TODO install texlive texlive texlive-lang-czechslovak texmaker
# TODO install exuberant-ctags

# update git submodules
git submodule init
git submodule update

# download, compile and install tmux
bash $APPCONFIG_PATH/tmux/install.sh

# compile and install tmuxinator
bash $APPCONFIG_PATH/tmuxinator/install.sh

# copy vim settings
bash $APPCONFIG_PATH/vim/install.sh

#############################################
# adding GIT_PATH variable to .bashrc 
#############################################

# add variable for path to the git repository
num=`cat ~/.bashrc | grep "GIT_PATH" | wc -l`
if [ "$num" -lt "1" ]; then

  TEMP=`( cd "$MY_PATH/../" && pwd )`

  echo "Adding GIT_PATH variable to .bashrc"
  # set bashrc
  echo "
# path to the git root
export GIT_PATH=$TEMP" >> ~/.bashrc

fi

#############################################
# add tmux sourcing of dotbashrd to .bashrc
#############################################

num=`cat ~/.bashrc | grep "RUN_TMUX" | wc -l`
if [ "$num" -lt "1" ]; then

  # ask whether to run tmux with new terminal
  read -r -p $'\033[31mDo you want to run TMUX automatically with every terminal? [y/n] \033[00m' response
  
  response=${response,,} # tolower
  if [[ $response =~ ^(yes|y| ) ]]; then

    echo "
# want to run tmux automatically with new terminal?
export RUN_TMUX=true" >> ~/.bashrc
  
    echo "Setting variable RUN_TMUX to true"
  else
  
    echo "
# want to run tmux automatically with new terminal?
export RUN_TMUX=false" >> ~/.bashrc
  
    echo "Setting variable RUN_TMUX to false"
  fi
fi

#############################################
# creating .vimpath file 
#############################################

# path for ctags
# path for file search

#############################################
# add sourcing of dotbashrd to .bashrc
#############################################
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

toilet Installation successful

# source .bashrc
source ~/.bashrc
