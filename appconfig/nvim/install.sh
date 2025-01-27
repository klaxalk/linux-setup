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

default=y
while true; do
  if [[ "$unattended" == "1" ]]
  then
    resp=$default
  else
    [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall neovim? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    echo Setting up neovim

    # install neovim
    sudo apt-get -y install neovim

    # set vim as a default git mergetool
    git config --global merge.tool vimdiff

    # link the configuration
    mkdir -p ~/.config/nvim
    ln -sf $APP_PATH/dotvim/* ~/.config/nvim/

    # install coc.nvim dependencies
    sudo apt-get -y install nodejs npm

    # cland for c++ in coc.nvim
    sudo apt-get -y install clangd clang-format

    # used as a grepper for telescope.nvim
    sudo apt-get -y install ripgrep

    # updated new plugins and clean old plugins
    /usr/bin/nvim -E -c "let g:user_mode=1" -c "so $APP_PATH/dotvimrc" -c "PlugInstall" -c "wqa" || echo "It normally returns >0"

    # link the ultisnips snippets
    [ -e ~/.config/coc/ultisnips ] && rm -rf ~/.config/coc/ultisnips
    ln -sf $APP_PATH/ultisnips ~/.config/coc

echo "All extensions installed!"

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
