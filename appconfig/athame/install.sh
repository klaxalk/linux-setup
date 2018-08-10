#!/bin/bash

# get the path to this script
APP_PATH=`dirname "$0"`
APP_PATH=`( cd "$APP_PATH" && pwd )`

default=y
while true; do
  [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall athame? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    # Ubuntu 16.04 does not have libreadline7 by default
    sudo add-apt-repository "deb http://cz.archive.ubuntu.com/ubuntu yakkety main universe restricted multiverse"
    sudo apt-get update
    sudo apt -y install libreadline7* libreadline-dev
    if [ "$?" != "0" ]; then echo "Press Enter to continues.."; read; fi

    if [ -x "$(whereis nvim | awk '{print $2}')" ]; then
      VIM_BIN="$(whereis nvim | awk '{print $2}')"
      HEADLESS="--headless"
    elif [ -x "$(whereis vim | awk '{print $2}')" ]; then
      VIM_BIN="$(whereis vim | awk '{print $2}')"
      HEADLESS=""
    fi

    # remove the yakkety source from the sources.list
    sudo $VIM_BIN $HEADLESS /etc/apt/sources.list -E -s -c ":%g/yakkety/norm dd" -c "wqa"
    sudo apt-get update

    sudo apt -y install curl
    if [ "$?" != "0" ]; then echo "Press Enter to continues.."; read; fi

    # compile athame from sources
    cd $APP_PATH/../../submodules/athame

    if [ -x "$(command -v nvim)" ]; then
      NEOVIM="--vimbin=$(which nvim)"
    elif [ -x "$(command -v vim)" ]; then
      NEOVIM=""
    fi

    # rebuild and patch readline7 with athame
    # sudo ./readline_athame_setup.sh --notest --libdir=/lib/x86_64-linux-gnu --use_sudo $NEOVIM
    # sudo ldconfig

    # fix wrong link of the library
    # sudo rm /lib/x86_64-linux-gnu/libreadline.so.7
    # sudo ln -sf /lib/x86_64-linux-gnu/libreadline.so.7.0 /lib/x86_64-linux-gnu/libreadline.so.7

    # build new bash with readline patched with athame
    # sudo ./bash_readline_setup.sh --use_sudo --notest $NEOVIM

    # build new zsh with readline patched with athame
    sudo ./zsh_athame_setup.sh --use_sudo --notest $NEOVIM

    default=y
    while true; do
      [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mUse athame by default? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
      response=`echo $resp | sed -r 's/(.*)$/\1=/'`

      if [[ $response =~ ^(y|Y)=$ ]]
      then

        # put $USE_ATHAME into bashrc
        num=`cat ~/.bashrc | grep "USE_ATHAME" | wc -l`
        if [ "$num" -lt "1" ]; then

          echo "
          # want to use athame?
          export USE_ATHAME=true" >> ~/.bashrc

        fi

        break

      elif [[ $response =~ ^(n|N)=$ ]]
      then

        # put $USE_ATHAME into bashrc
        num=`cat ~/.bashrc | grep "USE_ATHAME" | wc -l`
        if [ "$num" -lt "1" ]; then

          echo "
          # want to use athame?
          export USE_ATHAME=false" >> ~/.bashrc

        fi
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
