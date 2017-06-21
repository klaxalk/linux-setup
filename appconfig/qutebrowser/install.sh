#!/bin/bash

# get the path to this script
APP_PATH=`dirname "$0"`
APP_PATH=`( cd "$APP_PATH" && pwd )`

default=y
while true; do
  [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall qutebrowser? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    toilet Installing qutebrowser

    # install dependencies
    sudo apt-get -y install python3-lxml python-tox python3-pyqt5 python3-pyqt5.qtwebkit python3-pyqt5.qtquick python3-sip python3-jinja2 python3-pygments python3-yaml

    cd /tmp
    wget https://qutebrowser.org/python3-pypeg2_2.15.2-1_all.deb
    sudo dpkg -i python3-pypeg2_*_all.deb

    wget https://github.com/qutebrowser/qutebrowser/releases/download/v0.10.1/qutebrowser_0.10.1-1_all.deb
    sudo dpkg -i qutebrowser_*_all.deb

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
