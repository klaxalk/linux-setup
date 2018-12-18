#!/bin/bash

# needs newer gtk
# GIRARA_VERSION=0.2.7
# ZATHURA_VERSION=0.3.7
# ZATHURA_PDF_POPPLER_VERSION=0.2.7

GIRARA_VERSION=0.2.6
ZATHURA_VERSION=0.3.6
ZATHURA_PDF_POPPLER_VERSION=0.2.7

# get the path to this script
APP_PATH=`dirname "$0"`
APP_PATH=`( cd "$APP_PATH" && pwd )`

default=y
while true; do
  [[ -t 0 ]] && { read -t 5 -n 2 -p $'\e[1;32mInstall Zathura? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    sudo apt -y remove zathura libgirara-dev
    if [ "$?" != "0" ]; then echo "Press Enter to continues.."; read; fi

    # sudo apt -y remove zathura-pdf-poppler
    sudo apt -y install libmagic-dev libsynctex1 libsynctex-dev libgtk-3-dev xdotool latexmk libpoppler-glib-dev
    if [ "$?" != "0" ]; then echo "Press Enter to continues.."; read; fi

    sudo rm -rf /tmp/girara /tmp/zathura /tmp/zathura-pdf-poppler

    cd /tmp && git clone https://git.pwmt.org/pwmt/girara.git && cd girara && git checkout $GIRARA_VERSION && make && sudo make install
    cd /tmp && git clone https://git.pwmt.org/pwmt/zathura.git && cd zathura && git checkout $ZATHURA_VERSION && make WITH_SYNCTEX=1 && sudo make install
    cd /tmp && git clone https://github.com/pwmt/zathura-pdf-poppler.git && cd zathura-pdf-poppler && git checkout $ZATHURA_PDF_POPPLER_VERSION && make && sudo make install

    # cd /tmp/girara
    # sudo make uninstall

    # cd /tmp/zathura
    # sudo make uninstall

    # cd /tmp/zathura-pf-poppler
    # sudo make uninstall

    sudo rm -rf /tmp/girara /tmp/zathura /tmp/zathura-pdf-poppler

    mkdir -p ~/.config/zathura

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
