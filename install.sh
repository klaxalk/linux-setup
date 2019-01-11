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

sudo apt -y install cmake cmake-curses-gui ruby git sl htop indicator-multiload figlet toilet gem ruby build-essential tree exuberant-ctags libtool automake autoconf autogen libncurses5-dev python2.7-dev python3-dev libc++-dev openssh-server pandoc xclip xsel python-git vlc pkg-config python-setuptools python3-setuptools ffmpeg sketch xserver-xorg-video-intel shutter silversearcher-ag exfat-fuse exfat-utils xserver-xorg-input-synaptics python3-pip blueman gimp autossh jq okular dvipng
if [ "$?" != "0" ]; then echo "Press Enter to continues.."; read; fi

var1="18.04"
var2=`lsb_release -r | awk '{ print $2 }'`
if [ "$var2" = "$var1" ]; then
  export BEAVER=1
fi

if [ ! -n "$BEAVER" ]; then
  sudo apt -y install pdftk 
  if [ "$?" != "0" ]; then echo "Press Enter to continues.."; read; fi
fi

# download, compile and install tmux
bash $APPCONFIG_PATH/tmux/install.sh

# compile and install tmuxinator
bash $APPCONFIG_PATH/tmuxinator/install.sh

# copy vim settings
bash $APPCONFIG_PATH/vim/install.sh

# compile and install zsh with athame
bash $APPCONFIG_PATH/zsh/install.sh

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

# install the silver searcher
bash $APPCONFIG_PATH/silver_searcher/install.sh

# install debugging tools (gdb and some mods for it)
bash $APPCONFIG_PATH/gdb/install.sh

# install modified keyboard rules
bash $APPCONFIG_PATH/keyboard/install.sh

#############################################
# remove the interactivity check from bashrc
#############################################

if [ -x "$(whereis nvim | awk '{print $2}')" ]; then
  VIM_BIN="$(whereis nvim | awk '{print $2}')"
  HEADLESS="--headless"
elif [ -x "$(whereis vim | awk '{print $2}')" ]; then
  VIM_BIN="$(whereis vim | awk '{print $2}')"
  HEADLESS=""
fi

$VIM_BIN $HEADLESS -E -s -c "%g/running interactively/norm dap" -c "wqa" -- ~/.bashrc

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
# link the scripts folder
#############################################

if [ ! -e ~/.scripts ]; then
  ln -sf $MY_PATH/scripts ~/.scripts
fi

#############################################
# add PROFILES variables
#############################################

num=`cat ~/.bashrc | grep "PROFILES_ADDITIONS" | wc -l`
if [ "$num" -lt "1" ]; then

  echo "Adding epigen rules to .bashrc"
  echo '
# profiling options for EPIGEN
export PROFILES_ADDITIONS=""
export PROFILES_DELETIONS=""
export PROFILES_BOTH="COLORSCHEME_DARK"' >> ~/.bashrc

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


# deploy configs by Profile manager
./deploy_configs.sh

# finally source the correct rc file
toilet All Done

# say some tips to the new user
echo Huray, the should be ready, try opening new terminal...
