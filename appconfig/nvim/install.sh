#!/bin/bash

# get the path to this script
APP_PATH=`dirname "$0"`
APP_PATH=`( cd "$APP_PATH" && pwd )`

default=y
while true; do
  [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall NEOVIM? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    toilet Installing neovim

    sudo apt -y install neovim
    if [ "$?" != "0" ]; then echo "Press Enter to continues.."; read; fi
    mkdir -p ~/.config/nvim/

    sudo pip3 install neovim

    if [ ! -e ~/.config/nvim/init.vim ]; then
      ln -sf $APP_PATH/../vim/dotvimrc ~/.config/nvim/init.vim
    fi

    ln -sf $APP_PATH/../vim/dotvim/* ~/.config/nvim/

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
