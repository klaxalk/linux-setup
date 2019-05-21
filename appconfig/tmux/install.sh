#!/bin/bash

# get the path to this script
APP_PATH=`dirname "$0"`
APP_PATH=`( cd "$APP_PATH" && pwd )`

var1="18.04"
var2=`lsb_release -r | awk '{ print $2 }'`
if [ "$var2" = "$var1" ]; then
  export BEAVER=1
fi

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

    if [ -n "$BEAVER" ]; then

      sudo apt -y install tmux
      if [ "$?" != "0" ]; then echo "Press Enter to continues.."; read; fi

    else

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

    fi

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
