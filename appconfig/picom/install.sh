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

var1="18.04"
var2=`lsb_release -r | awk '{ print $2 }'`
[ "$var2" = "$var1" ] && export BEAVER=1

default=n
while true; do
  if [[ "$unattended" == "1" ]]
  then
    resp=$default
  else
    [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall picom (Compton alternative)? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    echo "Installing dependencies"
    sudo apt install libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-dpms0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libxcb-glx0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl-dev libegl-dev libpcre2-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev meson asciidoc

    cd $APP_PATH/../../submodules/picom
    git submodule update --init --recursive
    meson setup --buildtype=release . build
    ninja -C build
    sudo ninja -C build install
    
    # # copy i3 config file
    # cp $APP_PATH/doti3/config_git ~/.i3/config
    # cp $APP_PATH/doti3/i3blocks.conf_git ~/.i3/i3blocks.conf
    # cp $APP_PATH/i3blocks/wifi_git $APP_PATH/i3blocks/wifi
    # cp $APP_PATH/i3blocks/battery_git $APP_PATH/i3blocks/battery

    # # copy fonts
    # # fontawesome 4.7
    # mkdir -p ~/.fonts
    # cp $APP_PATH/fonts/* ~/.fonts/

    # # link fonts.conf file
    # mkdir -p ~/.config/fontconfig
    # ln -sf $APP_PATH/fonts.conf ~/.config/fontconfig/fonts.conf

    # # install useful gui utils
    # sudo apt-get -y install thunar rofi compton systemd

    # $APP_PATH/make_launchers.sh $APP_PATH/../../scripts

    # # disable nautilus
    # gsettings set org.gnome.desktop.background show-desktop-icons false

    # # install xkb layout state
    # cd $APP_PATH/../../submodules/xkblayout-state/
    # make
    # sudo ln -sf $APP_PATH/../../submodules/xkblayout-state/xkblayout-state /usr/bin/xkblayout-state

    # sudo apt-get -y install i3lock

    # # install prime-select (for switching gpus)
    # # sudo apt-get -y install nvidia-prime

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi

done
