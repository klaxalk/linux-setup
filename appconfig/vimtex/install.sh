#!/bin/bash
GIRARA_VERSION=0.2.6
ZATHURA_VERSION=0.3.6

while true; do
  [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mSet up for Latex development? (Y/n)\e[0m\n' resp || resp="y" ; }
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    sudo apt-get -y install texlive texlive texlive-lang-czechslovak texmaker

    sudo apt-get -y install zathura-pdf-poppler libsynctex1 libsynctex-dev libgtk-3-dev xdotool latexmk

    # otherwise the own girara compilation will not work
    sudo apt-get -y remove libgirara-dev

    # need for zathura compilation
    sudo apt-get -y install libmagic-dev

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
