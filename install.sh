#!/bin/bash

set -e

trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "$0: \"${last_command}\" command failed with exit code $?"' ERR

# get the path to this script
MY_PATH=`dirname "$0"`
MY_PATH=`( cd "$MY_PATH" && pwd )`

# define paths
APPCONFIG_PATH=$MY_PATH/appconfig

# install packages
sudo apt-get -y update

subinstall_params=""
unattended=0
docker=false
for param in "$@"
do
  echo $param
  if [ $param="--unattended" ]; then
    echo "installing in unattended mode"
    unattended=1
    subinstall_params="--unattended"
  fi
  if [ $param="--docker" ]; then
    echo "installing in docker mode"
    docker=true
  fi
done

cd $MY_PATH
$docker && git submodule update --init --recursive --recommend-shallow
! $docker && git submodule update --init --recursive

var1="18.04"
var2=`lsb_release -r | awk '{ print $2 }'`
[ "$var2" = "$var1" ] && export BEAVER=1

arch=`uname -i`

# essentials
sudo apt-get -y install git tig cmake cmake-curses-gui build-essential automake autoconf autogen libncurses5-dev libc++-dev pkg-config libtool net-tools openssh-server nmap

# python
sudo apt-get -y install python3-dev python-setuptools python3-setuptools python3-wheel python3-pip python3-git

# other stuff
sudo apt-get -y install ruby sl indicator-multiload figlet toilet gem tree exuberant-ctags xclip xsel exfat-fuse exfat-utils blueman autossh jq xvfb gparted espeak ncdu pavucontrol

if [ "$unattended" == "0" ]
then
  if [ "$?" != "0" ]; then echo "Press Enter to continues.." && read; fi
fi

# install TMUX
bash $APPCONFIG_PATH/tmux/install.sh $subinstall_params

# setup RANGER
bash $APPCONFIG_PATH/ranger/install.sh $subinstall_params

# install VIM
bash $APPCONFIG_PATH/vim/install.sh $subinstall_params

# install HTOP-VIM
bash $APPCONFIG_PATH/htop-vim/install.sh $subinstall_params

# install URXVT
! $docker && bash $APPCONFIG_PATH/urxvt/install.sh $subinstall_params

# install FONTS POWERLINE
! $docker && bash $APPCONFIG_PATH/fonts-powerline/install.sh $subinstall_params

# install NVIM
# bash $APPCONFIG_PATH/nvim/install.sh $subinstall_params

# install ZSH with ATHAME
! $docker && bash $APPCONFIG_PATH/zsh/install.sh $subinstall_params

# install I3
! $docker && bash $APPCONFIG_PATH/i3/install.sh $subinstall_params

# install LATEX and PDF support
! $docker && bash $APPCONFIG_PATH/latex/install.sh $subinstall_params

# install PDFPC
! $docker && bash $APPCONFIG_PATH/pdfpc/install.sh $subinstall_params

# install MULTIMEDIA support
! $docker && bash $APPCONFIG_PATH/multimedia/install.sh $subinstall_params

# install PANDOC
if [ "$arch" != "aarch64" ]; then
  ! $docker && bash $APPCONFIG_PATH/pandoc/install.sh $subinstall_params
fi

# install SHUTTER
if [ "$arch" != "aarch64" ]; then
  ! $docker && bash $APPCONFIG_PATH/shutter/install.sh $subinstall_params
fi

# install ZATHURA
! $docker && bash $APPCONFIG_PATH/zathura/install.sh $subinstall_params

# install VIMIV
! $docker && bash $APPCONFIG_PATH/vimiv/install.sh $subinstall_params

# install SILVER SEARCHER (ag)
bash $APPCONFIG_PATH/silver_searcher/install.sh $subinstall_params

# setup modified keyboard rules
! $docker && bash $APPCONFIG_PATH/keyboard/install.sh $subinstall_params

# setup fuzzyfinder
bash $APPCONFIG_PATH/fzf/install.sh $subinstall_params

# install PLAYERCTL
if [ "$arch" != "aarch64" ]; then
  ! $docker && bash $APPCONFIG_PATH/playerctl/install.sh $subinstall_params
fi

# install PAPIS
! $docker && bash $APPCONFIG_PATH/papis/install.sh $subinstall_params

# install VIM-STREAM
bash $APPCONFIG_PATH/vim-stream/install.sh $subinstall_params

# install GRUB CUSTOMIZER
if [ "$arch" != "aarch64" ]; then
  ! $docker && bash $APPCONFIG_PATH/grub-customizer/install.sh $subinstall_params
fi

# install TMUXINATOR
! $docker && bash $APPCONFIG_PATH/tmuxinator/install.sh $subinstall_params

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

# this caused some problems once, but where?
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

##################################################
# install inputs libraries when they are missing
##################################################
sudo apt-get -y install xserver-xorg-input-all

#############################################
# Disable automatic update over apt
#############################################

sudo systemctl disable apt-daily.service
sudo systemctl disable apt-daily.timer

sudo systemctl disable apt-daily-upgrade.timer
sudo systemctl disable apt-daily-upgrade.service

#############################################
# link the scripts folder
#############################################

if [ ! -e ~/.scripts ]; then
  ln -sf $MY_PATH/scripts ~/.scripts
fi

#############################################
# add PROFILES variables
#############################################

num=`cat ~/.bashrc | grep "PROFILES" | wc -l`
if [ "$num" -lt "1" ]; then

  echo "Adding epigen rules to .bashrc"
  echo '
# list (space-separated) of profile names for customizing configs
export PROFILES="COLORSCHEME_DARK"' >> ~/.bashrc

fi

#############################################
# fix touchpad touch-clicking
#############################################

if [ !docker ] && [ ! -e /etc/X11/xorg.conf.d/90-touchpad.conf ]; then
  $MY_PATH/scripts/fix_touchpad_click.sh
fi

#############################################
# add sourcing of dotbashrd to .bashrc
#############################################
num=`cat ~/.bashrc | grep "dotbashrc" | wc -l`
if [ "$num" -lt "1" ]; then

  echo "Adding source to .bashrc"
  # set bashrc
  echo "
# sourcing Tomas's linux setup
source $APPCONFIG_PATH/bash/dotbashrc" >> ~/.bashrc

fi

#############################################
# link dotclang-tidy to ~/.clang-tidy
# (enable linting for YCM)
#############################################
ln -sf "$APPCONFIG_PATH/clangd/dotclang-tidy" ~/.clang-tidy

# deploy configs by Profile manager
./deploy_configs.sh

# say some tips to the new user
echo "Hurray, the 'Linux Setup' should be ready, try opening a new terminal."
