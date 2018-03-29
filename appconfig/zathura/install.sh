#!/bin/bash
GIRARA_VERSION=0.2.7
ZATHURA_VERSION=0.3.7
ZATHURA_PDF_POPPLER_VERSION=0.3.7

# get the path to this script
APP_PATH=`dirname "$0"`
APP_PATH=`( cd "$APP_PATH" && pwd )`

default=y
while true; do
  [[ -t 0 ]] && { read -t 5 -n 2 -p $'\e[1;32mInstall Zathura? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    sudo apt-get -y install libsynctex1 libsynctex-dev libgtk-3-dev xdotool latexmk

    # otherwise the own girara compilation will not work
    sudo apt-get -y remove libgirara-dev

    # need for zathura compilation
    sudo apt-get -y install libmagic-dev

    rm -rf /tmp/girara /tmp/zathura /tmp/zathura-pdf-poppler

    cd /tmp && git clone https://git.pwmt.org/pwmt/girara.git && cd girara && git checkout $GIRARA_VERSION && make && sudo make install
    cd /tmp && git clone https://git.pwmt.org/pwmt/zathura.git && cd zathura && git checkout $ZATHURA_VERSION && make WITH_SYNCTEX=1 && sudo make install
    cd /tmp && git clone https://git@github.com:pwmt/zathura-pdf-poppler.git && cd zatura-pdf-poppler && git checkout $ZATHURA_PDF_POPPLER_VERSION && make && sudo make install
    # link zathuras config
    mkdir ~/.config/zathura
    cp $APP_PATH/zathurarc ~/.config/zathura/zathurarc

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
