#!/bin/bash

# get the path to this script
APP_PATH=`dirname "$0"`
APP_PATH=`( cd "$APP_PATH" && pwd )`

# img2txt
sudo apt -y install ranger caca-utils libimage-exiftool-perl

# symlink vim settings
rm ~/.config/ranger/rifle.conf
rm ~/.config/ranger/commands.py
rm ~/.config/ranger/rc.conf
rm ~/.config/ranger/scope.sh

ln -s $APP_PATH/rifle.conf ~/.config/ranger/rifle.conf
ln -s $APP_PATH/commands.py ~/.config/ranger/commands.py
ln -s $APP_PATH/rc.conf ~/.config/ranger/rc.conf
ln -s $APP_PATH/scope.sh ~/.config/ranger/scope.sh
