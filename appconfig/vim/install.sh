#!/bin/bash

set -e

trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "$0: \"${last_command}\" command failed with exit code $?"' ERR

# get the path to this script
APP_PATH=`dirname "$0"`
APP_PATH=`( cd "$APP_PATH" && pwd )`

unattended=0
subinstall_params=""
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

default=y
while true; do
  if [[ "$unattended" == "1" ]]
  then
    resp=$default
  else
    [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall vim? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    toilet Setting up vim

    sudo apt-get -y remove vim-* || echo ""

    if [ -n "$BEAVER" ]; then
      sudo apt-get -y install libgnome2-dev libgnomeui-dev libbonoboui2-dev
    fi

    sudo apt-get -y install libncurses5-dev libgtk2.0-dev libatk1.0-dev libcairo2-dev libx11-dev libxpm-dev libxt-dev python3-dev clang-format

    sudo -H pip3 install rospkg

    # compile vim from sources
    cd $APP_PATH/../../submodules/vim
    ./configure --with-features=huge \
      --enable-multibyte \
      --enable-python3interp=yes \
      --with-python3-config-dir=/usr/lib/python3.5/config-3.5m-x86_64-linux-gnu \
      --enable-perlinterp=yes \
      --enable-luainterp=yes \
      --enable-cscope --prefix=/usr

      cd src
      make
      cd ../
      make VIMRUNTIMEDIR=/usr/share/vim/vim81
      sudo make install

    # set vim as a default git mergetool
    git config --global merge.tool vimdiff

    # symlink vim settings
    rm -rf ~/.vim
    ln -fs $APP_PATH/dotvim ~/.vim

    # updated new plugins and clean old plugins
    /usr/bin/vim -E -c "let g:user_mode=1" -c "so $APP_PATH/dotvimrc" -c "PlugInstall" -c "wqa" || echo "It normally returns >0"

    default=y
    while true; do
      if [[ "$unattended" == "1" ]]
      then
        resp=$default
      else
        [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mCompile YouCompleteMe? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
      fi
      response=`echo $resp | sed -r 's/(.*)$/\1=/'`

      if [[ $response =~ ^(y|Y)=$ ]]
      then

        # set youcompleteme
        toilet Setting up youcompleteme

        sudo apt-get -y install libboost-all-dev

        cd ~/.vim/plugged/youcompleteme/
        git submodule update --init --recursive
        python3 ./install.py --clang-completer

        # link .ycm_extra_conf.py
        ln -fs $APP_PATH/dotycm_extra_conf.py ~/.ycm_extra_conf.py

        break
      elif [[ $response =~ ^(n|N)=$ ]]
      then
        break
      else
        echo " What? \"$resp\" is not a correct answer. Try y+Enter."
      fi
    done

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
