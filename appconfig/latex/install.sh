#!/bin/bash

# get the path to this script
APP_PATH=`dirname "$0"`
APP_PATH=`( cd "$APP_PATH" && pwd )`

default=n
while true; do
  [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mSet up for Latex support? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    sudo apt-get -y install texlive texlive-latex-extra texlive-lang-czechslovak texmaker

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
