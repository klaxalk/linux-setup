#!/bin/bash

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

default=n
while true; do
  if [[ "$unattended" == "1" ]]
  then
    resp=$default
  else
    [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall zshell (with athame)? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    sudo apt -y install curl
    if [ "$?" != "0" ]; then echo "Press Enter to continues.."; read; fi

    # compile athame from sources
    cd $APP_PATH/../../submodules/athame

    if [ -x "$(command -v vim)" ]; then
      NEOVIM="--vimbin=/usr/bin/vim"
    elif [ -x "$(command -v nvim)" ]; then
      NEOVIM="--vimbin=/usr/bin/nvim"
    fi

    # build new zsh with readline patched with athame
    sudo ./zsh_athame_setup.sh --notest --use_sudo $NEOVIM

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

    num=`cat ~/.zshrc | grep "USE_ATHAME" | wc -l`
    if [ "$num" -lt "1" ]; then

      echo "Adding USE_ATHAME variable to .zshrc"
      echo '
# should use Athame by default?
export USE_ATHAME="true"' >> ~/.zshrc

    fi

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
