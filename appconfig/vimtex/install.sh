#!/bin/bash
GIRARA_VERSION=0.2.6
ZATHURA_VERSION=0.3.6

resp=y
[[ -t 0 ]] && {
read -t 10 -n 1 -p $'\e[1;32mSet up Latex? (Y/n)\e[0m\n' resp || resp=y ; }
if [[ $resp =~ ^(y|Y|)$ ]]
then

  sudo apt-get install texlive texlive texlive-lang-czechslovak texmaker

  sudo apt-get install zathura-pdf-poppler libsynctex1 libsynctex-dev libgtk-3-dev xdotool latexmk

  # otherwise the own girara compilation will not work
  sudo apt-get remove libgirara-dev

  # need for zathura compilation
  sudo apt-get install libmagic-dev

  rm -rf /tmp/girara /tmp/zathura

  cd /tmp && git clone https://git.pwmt.org/pwmt/girara.git && cd girara && git checkout $GIRARA_VERSION && make && sudo make install
  cd /tmp && git clone https://git.pwmt.org/pwmt/zathura.git && cd zathura && git checkout $ZATHURA_VERSION && make WITH_SYNCTEX=1 && sudo make install

fi
