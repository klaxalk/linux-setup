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
    [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall pdfpc? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    sudo apt-get -y install pdfpc

    ## | ----------------- old manual compilation ----------------- |

    # install prerequisities
    # sudo apt-get -y install cmake valac libgee-0.8-dev libpoppler-glib-dev \
    # libgtk-3-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
    # libjson-glib-dev libmarkdown2-dev libwebkit2gtk-4.0-dev libsoup2.4-dev \
    # libqrencode-dev gstreamer1.0-gtk3

    # # use in pdfpc to play videos
    # sudo apt-get -y install gstreamer1.0-libav

    # # compile and install pdfpc
    # cd $APP_PATH/../../submodules/pdfpc/
    # [ ! -e build ] && mkdir build
    # cd build
    # cmake ..
    # make
    # sudo make install

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
