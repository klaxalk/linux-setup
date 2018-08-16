#!/bin/bash

# get the path to this script
APP_PATH=`dirname "$0"`
APP_PATH=`( cd "$APP_PATH" && pwd )`

default=y
while true; do
  [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall zshell (with athame)? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    sudo apt -y install curl
    if [ "$?" != "0" ]; then echo "Press Enter to continues.."; read; fi

    # compile athame from sources
    cd $APP_PATH/../../submodules/athame

    if [ -x "$(command -v nvim)" ]; then
      NEOVIM="--vimbin=$(which nvim)"
    elif [ -x "$(command -v vim)" ]; then
      NEOVIM=""
    fi

    # build new zsh with readline patched with athame
    sudo ./zsh_athame_setup.sh --use_sudo --notest $NEOVIM

    # install oh-my-zsh
    sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

    # symlink plugins
    if [ ! -e ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then
      ln -sf $APP_PATH/../../submodules/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    fi

    # symlink the .zshrc
    num=`cat ~/.zshrc | grep "dotzshrc" | wc -l`
    if [ "$num" -lt "1" ]; then
      cp $APP_PATH/dotzshrc_template ~/.zshrc
    fi

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
