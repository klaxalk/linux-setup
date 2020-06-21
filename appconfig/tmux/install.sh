#!/bin/bash

set -e

trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "$0: \"${last_command}\" command failed with exit code $?"' ERR

# get the path to this script
APP_PATH=`dirname "$0"`
APP_PATH=`( cd "$APP_PATH" && pwd )`

var1="18.04"
var2=`lsb_release -r | awk '{ print $2 }'`
if [ "$var2" = "$var1" ]; then
  export BEAVER=1
fi

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

default=y
while true; do
  if [[ "$unattended" == "1" ]]
  then
    resp=$default
  else
    [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall TMUX? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    toilet Installing tmux

    sudo apt -y remove tmux

    sudo apt -y install autotools-dev autoconf libtool libtool-bin

    # # install libevent
    # cd /tmp
    # wget https://github.com/libevent/libevent/releases/download/release-2.1.11-stable/libevent-2.1.11-stable.tar.gz
    # tar -xvf libevent-2.1.11-stable.tar.gz
    # rm libevent-2.1.11-stable.tar.gz
    # cd libevent-2.1.11-stable
    # ./configure && make
    # sudo make install

    # libevent
    cd $APP_PATH/../../submodules/libevent
    ./autogen.sh
    ./configure
    make
    sudo make install

    export LIBEVENT_LIBS="-L/usr/local/lib -levent -Wl,-rpath -Wl,/usr/local/lib"

    # instal tmux
    cd $APP_PATH/../../submodules/tmux
    ./autogen.sh
    ./configure && make -j4
    sudo make install-binPROGRAMS

    #############################################
    # add TMUX enable/disable to .bashrc
    #############################################

    num=`cat ~/.bashrc | grep "RUN_TMUX" | wc -l`
    if [ "$num" -lt "1" ]; then

      default=y
      while true; do
        if [[ "$unattended" == "1" ]]
        then
          resp=$default
        else
          [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mDo you want to run TMUX automatically with every terminal? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
        fi
        response=`echo $resp | sed -r 's/(.*)$/\1=/'`

        if [[ $response =~ ^(y|Y)=$ ]]
        then

          echo "
# run Tmux automatically in every normal terminal
export RUN_TMUX=true" >> ~/.bashrc

          echo "Setting variable RUN_TMUX to true in .bashrc"

          break
        elif [[ $response =~ ^(n|N)=$ ]]
        then

          echo "
# run Tmux automatically in every normal terminal
export RUN_TMUX=false" >> ~/.bashrc

          echo "Setting variable RUN_TMUX to false in .bashrc"

          break
        else
          echo " What? \"$resp\" is not a correct answer. Try y+Enter."
        fi
      done
    fi

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
