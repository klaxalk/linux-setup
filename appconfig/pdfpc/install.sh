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

beaver_ver="18.04"
numbat_ver="24.04"
lsb=`lsb_release -r | awk '{ print $2 }'`
[ "$lsb" = "$beaver_ver" ] && export BEAVER=1
[ "$lsb" = "$numbat_ver" ] && export NUMBAT=1

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

    # install prerequisities
    if [ -n "$NUMBAT" ]; then
      sudo apt-get install pdf-presenter-console
    else
      sudo apt-get -y install cmake valac libgee-0.8-dev libpoppler-glib-dev \
      libgtk-3-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
      libjson-glib-dev libmarkdown2-dev libwebkit2gtk-4.0-dev libsoup2.4-dev \
      libqrencode-dev gstreamer1.0-gtk3

      # compile and install pdfpc
      cd $APP_PATH/../../submodules/pdfpc/
      [ ! -e build ] && mkdir build
      cd build
      cmake ..
      make
      sudo make install
    fi


    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
