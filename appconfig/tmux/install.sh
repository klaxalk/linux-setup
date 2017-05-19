#!/bin/bash

# get the path to this script
APP_PATH=`dirname "$0"`
APP_PATH=`( cd "$APP_PATH" && pwd )`

resp=y
[[ -t 0 ]] && {
read -t 10 -n 1 -p $'\033[31mInstall TMUX? [y/n] \033[00m' resp || resp=y ; }
if [[ $resp =~ ^(y|Y|)$ ]]
then

  toilet Installing tmux

  libevent=`ldconfig -p | grep libevent-2.0 | wc -l`
  if [ "$libevent" -lt "2" ]; then

    echo $'\033[31mLibevent not installed, installing... \033[00m' 

    # install libevent
    cd /tmp
    wget https://github.com/libevent/libevent/releases/download/release-2.0.22-stable/libevent-2.0.22-stable.tar.gz
    tar -xvf libevent-2.0.22-stable.tar.gz
    rm libevent-2.0.22-stable.tar.gz
    cd libevent-2.0.22-stable
    ./configure && make >> /dev/null
    sudo make install

  fi
  
  # instal tmux
  cd $APP_PATH/../../submodules/tmux
  sh autogen.sh
  ./configure && make -j4
  sudo make install-binPROGRAMS
  git clean -fd

  # symlink tmux settings
  rm ~/.tmux.conf
  ln -s $APP_PATH/dottmux.conf ~/.tmux.conf

fi
