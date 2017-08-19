#!/bin/bash
GIRARA_VERSION=0.2.6
ZATHURA_VERSION=0.3.6

# get the path to this script
APP_PATH=`dirname "$0"`
APP_PATH=`( cd "$APP_PATH" && pwd )`

default=n
while true; do
  [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mSet up for Latex development? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    sudo apt-get -y install texlive texlive-latex-extra texlive-lang-czechslovak texmaker

    sudo apt-get -y install zathura-pdf-poppler libsynctex1 libsynctex-dev libgtk-3-dev xdotool latexmk

    # otherwise the own girara compilation will not work
    sudo apt-get -y remove libgirara-dev

    # need for zathura compilation
    sudo apt-get -y install libmagic-dev

    # link zathuras config
    ln -s $APP_PATH/../zathura/zathurarc ~/.config/zathura/zathurarc
k
    rm -rf /tmp/girara /tmp/zathura

    cd /tmp && git clone https://git.pwmt.org/pwmt/girara.git && cd girara && git checkout $GIRARA_VERSION && make && sudo make install
    cd /tmp && git clone https://git.pwmt.org/pwmt/zathura.git && cd zathura && git checkout $ZATHURA_VERSION && make WITH_SYNCTEX=1 && sudo make install

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
