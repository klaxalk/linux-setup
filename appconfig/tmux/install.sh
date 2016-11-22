#!/bin/bash

# install libevent
cd ~/git
wget https://github.com/libevent/libevent/releases/download/release-2.0.22-stable/libevent-2.0.22-stable.tar.gz
tar -xvf libevent-2.0.22-stable.tar.gz
rm libevent-2.0.22-stable.tar.gz
cd libevent-2.0.22-stable
./configure && make
sudo make install

# instal tmux
cd ~/git
git clone https://github.com/klaxalk/tmux.git
cd tmux
git pull
sh autogen.sh
./configure && make -j4
sudo make install-binPROGRAMS

# symlink tmux settings
rm ~/.tmux.conf
ln -s $APPCONFIG_PATH/appconfig/tmux/dottmux.conf ~/.tmux.conf

