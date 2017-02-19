#!/bin/bash

# get the path to this script
APP_PATH=`dirname "$0"`
APP_PATH=`( cd "$APP_PATH" && pwd )`

read -r -p $'\033[31mInstall i3? [y/n] \033[00m' response

response=${response,,} # tolower
if [[ $response =~ ^(yes|y|| ) ]]; then

  toilet installing i3

  # install i3
  sudo apt-get install i3

  # for brightness and volume control
  sudo apt-get install xbacklight alsa-utils pulseaudio feh arandr acpi

  # for making gtk look better
  sudo apt-get install lxappearance 
  
  # symlink i3 settings
  rm ~/.i3
  ln -s $APP_PATH/doti3 ~/.i3

  # copy fonts
  # fontawesome 4.7 
  mkdir ~/.fonts
  cp $APP_PATH/fonts/* ~/.fonts/

  # symlink gtk settings
  ln -s $APP_PATH/gtk/dotgtkrc-2.0 ~/.gtkrc-2.0
  rm ~/.config/gtk-3.0/settings.ini
  ln -s $APP_PATH/gtk/settings.ini ~/.config/gtk-3.0/

  # install thunar
  sudo apt-get install thunar gnome-icon-theme-full

  # install arc gtk theme if not installed
  if [ ! -f /etc/apt/sources.list.d/arc-theme.list ]; then

    wget http://download.opensuse.org/repositories/home:Horst3180/xUbuntu_15.04/Release.key
    sudo apt-key add - < Release.key
    sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_15.04/ /' > /etc/apt/sources.list.d/arc-theme.list"
    sudo apt-get update
    sudo apt-get install arc-theme
    
  fi

  # install moka icon theme
  sudo add-apt-repository ppa:moka/daily
  sudo apt-get update
  sudo apt-get install moka-icon-theme

  # install rofi
  cd /tmp
  wget https://launchpad.net/ubuntu/+source/rofi/0.15.11-1/+build/8289001/+files/rofi_0.15.11-1_amd64.deb
  sudo dpkg -i rofi_0.15.11-1_amd64.deb
  cd $APP_PATH

  # install compton
  sudo apt-get install compton

  # install i3blocks
  cd /tmp
  wget https://launchpad.net/ubuntu/+source/i3blocks/1.4-1/+build/7637635/+files/i3blocks_1.4-1_amd64.deb
  sudo dpkg -i i3blocks_1.4-1_amd64.deb
  cd $APP_PATH

  # put $USE_I3 into bashrc
  num=`cat ~/.bashrc | grep "USE_I3" | wc -l`
  if [ "$num" -lt "1" ]; then

    echo "
# do you use i3?
export USE_I3=true" >> ~/.bashrc

  fi
  
fi
