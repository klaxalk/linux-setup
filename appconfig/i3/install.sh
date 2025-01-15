#!/bin/bash

set -e

trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "$0: \"${last_command}\" command failed with exit code $?"' ERR

# get the path to this script
APP_PATH=`dirname "$0"`
APP_PATH=`( cd "$APP_PATH" && pwd )`

unattended=0
for param in "$@"
do
  echo $param
  if [ $param="--unattended" ]; then
    echo "installing in unattended mode"
    unattended=1
    subinstall_params="--unattended"
  fi
done

default=y
while true; do
  if [[ "$unattended" == "1" ]]
  then
    resp=$default
  else
    [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall i3? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    sudo apt-get -y install i3-wm i3blocks i3lock

    # required for i3-layout-manager
    sudo apt-get -y install jq rofi xdotool x11-xserver-utils indent libanyevent-i3-perl

    if [ "$unattended" == "0" ]; # if running interactively
    then
      # install graphical X11 graphical backend with lightdm loading screen
      echo ""
      echo "-----------------------------------------------------------------"
      echo "Installing lightdm login manager. It might require manual action."
      echo "-----------------------------------------------------------------"
      echo "If so, please select \"lightdm\", after hitting Enter"
      echo ""
      echo "Waiting for Enter..."
      echo ""
      read
    fi

    sudo apt-get -y install lightdm

    # for cpu usage in i3blocks
    sudo apt-get -y install sysstat

    # for brightness and volume control
    sudo apt-get -y install alsa-utils pulseaudio feh arandr

    # for setting up desktop wallpaper
    sudo apt-get -y install feh

    # for making gtk look better
    sudo apt-get -y install lxappearance

    # symlink settings folder
    if [ ! -e ~/.i3 ]; then
      ln -sf $APP_PATH/doti3 ~/.i3
    fi

    # copy i3 config file
    cp $APP_PATH/doti3/config_git ~/.i3/config
    cp $APP_PATH/doti3/i3blocks.conf_git ~/.i3/i3blocks.conf
    cp $APP_PATH/i3blocks/wifi_git $APP_PATH/i3blocks/wifi
    cp $APP_PATH/i3blocks/battery_git $APP_PATH/i3blocks/battery

    # copy fonts
    # fontawesome 4.7
    mkdir -p ~/.fonts
    cp $APP_PATH/fonts/* ~/.fonts/

    # link fonts.conf file
    mkdir -p ~/.config/fontconfig
    ln -sf $APP_PATH/fonts.conf ~/.config/fontconfig/fonts.conf

    # install useful gui utils
    sudo apt-get -y install rofi compton systemd

    $APP_PATH/make_launchers.sh $APP_PATH/../../scripts

    # disable nautilus
    # gsettings set org.gnome.desktop.background show-desktop-icons false

    # compile and install "light" for brightness control
    cd $APP_PATH/../../submodules/light
    ./autogen.sh
    ./configure --with-udev
    make
    sudo make install
    git clean -fd
    cd $APP_PATH

    # install xkb layout state
    cd $APP_PATH/../../submodules/xkblayout-state/
    make
    sudo ln -sf $APP_PATH/../../submodules/xkblayout-state/xkblayout-state /usr/bin/xkblayout-state
    cd $APP_PATH

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi

done
