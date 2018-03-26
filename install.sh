#!/bin/bash

# get the path to this script
MY_PATH=`dirname "$0"`
MY_PATH=`( cd "$MY_PATH" && pwd )`

# define paths
APPCONFIG_PATH=$MY_PATH/appconfig

cd $MY_PATH
git pull
git submodule update --init --recursive

# install packages
sudo apt-get -y update
sudo apt-get -y remove vim-*

sudo apt-get -y install cmake cmake-curses-gui ruby git sl htop git indicator-multiload figlet toilet gem ruby build-essential tree exuberant-ctags libtool automake autoconf autogen libncurses5-dev python3-dev python2.7-dev libc++-dev clang-3.8 clang-format openssh-server pandoc xclip xsel python-git vlc pkg-config pdftk python-setuptools python3-setuptools ffmpeg sketch python3-rospkg ros-kinetic-tf2*

# for mounting exfat
sudo apt-get -y install exfat-fuse exfat-utils

# download, compile and install tmux
bash $APPCONFIG_PATH/tmux/install.sh

# compile and install tmuxinator
bash $APPCONFIG_PATH/tmuxinator/install.sh

# copy vim settings
bash $APPCONFIG_PATH/vim/install.sh

# install urxvt
bash $APPCONFIG_PATH/urxvt/install.sh

# install i3
bash $APPCONFIG_PATH/i3/install.sh

# setup latex
bash $APPCONFIG_PATH/latex/install.sh

# setup zathura
bash $APPCONFIG_PATH/zathura/install.sh

# setup ranger
bash $APPCONFIG_PATH/ranger/install.sh

# setup vimiv
bash $APPCONFIG_PATH/vimiv/install.sh

# install athame
bash $APPCONFIG_PATH/athame/install.sh

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

  default=y
  while true; do
    [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mDo you want to run TMUX automatically with every terminal? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
    response=`echo $resp | sed -r 's/(.*)$/\1=/'`

    if [[ $response =~ ^(y|Y)=$ ]]
    then

    echo "
# want to run tmux automatically with new terminal?
export RUN_TMUX=true" >> ~/.bashrc
  
    echo "Setting variable RUN_TMUX to true"

      break
    elif [[ $response =~ ^(n|N)=$ ]]
    then

    echo "
# want to run tmux automatically with new terminal?
export RUN_TMUX=false" >> ~/.bashrc
  
    echo "Setting variable RUN_TMUX to false"

      break
    else
      echo " What? \"$resp\" is not a correct answer. Try y+Enter."
    fi
  done
fi

#############################################
# add PROFILER variables
#############################################

num=`cat ~/.bashrc | grep "PROFILER_ADDITIONS" | wc -l`
if [ "$num" -lt "1" ]; then

# what should be activated/deactivated by epigen?
export PROFILER_ADDITIONS=""
export PROFILER_DELETIONS=""
export PROFILER_BOTH="COLORSCHEME_DARK"

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

  cp $APPCONFIG_PATH/bash/dotbashrc_git $APPCONFIG_PATH/bash/dotbashrc

  echo "Adding source to .bashrc"
  # set bashrc
  echo "
# sourcing tomas's tmux preparation
source $APPCONFIG_PATH/bash/dotbashrc" >> ~/.bashrc

else

  echo "Reference in .bashrc is already there..."

fi

toilet All Done

# source .bashrc
case "$SHELL" in 
  *bash*)
    source "$HOME/.bashrc"
    ;;
  *zsh*)
    source "$HOME/.zshrc"
    ;;
esac

cd "$APPCONFIG_PATH/.."
git pull
