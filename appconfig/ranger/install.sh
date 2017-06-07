#!/bin/bash

# get the path to this script
APP_PATH=`dirname "$0"`
APP_PATH=`( cd "$APP_PATH" && pwd )`

# symlink vim settings
rm ~/.config/ranger/rifle.conf
ln -s $APP_PATH/rifle.conf ~/.config/ranger/rifle.conf
