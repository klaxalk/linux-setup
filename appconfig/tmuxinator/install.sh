#!/bin/bash

# install tmuxinator
cd $SUBMOBULES_PATH/tmuxinator
git pull
sudo gem install tmuxinator

# symlink tmuxinator settings
rm ~/.tmuxinator
ln -s $APPCONFIG_PATH/tmuxinator/dottmuxinator ~/.tmuxinator
