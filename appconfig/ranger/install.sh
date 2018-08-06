#!/bin/bash

# get the path to this script
APP_PATH=`dirname "$0"`
APP_PATH=`( cd "$APP_PATH" && pwd )`

# img2txt
sudo apt -y install ranger caca-utils libimage-exiftool-perl
if [ "$?" != "0" ]; then echo "Press Enter to continues.."; read; fi

# symlink vim settings
rm ~/.config/ranger/rifle.conf
rm ~/.config/ranger/commands.py
rm ~/.config/ranger/rc.conf
rm ~/.config/ranger/scope.sh

mkdir ~/.config/ranger

ln -fs $APP_PATH/rifle.conf ~/.config/ranger/rifle.conf
ln -fs $APP_PATH/commands.py ~/.config/ranger/commands.py
ln -fs $APP_PATH/rc.conf ~/.config/ranger/rc.conf
ln -fs $APP_PATH/scope.sh ~/.config/ranger/scope.sh
