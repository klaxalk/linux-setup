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

default=n
while true; do
  if [[ "$unattended" == "1" ]]
  then
    resp=$default
  else
    [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall multimedia support (editors, players, ...)? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    # for video, photo, audio, ..., viewing and editing
    sudo apt-get -y install gimp vlc ffmpeg audacity rawtherapee hugin pavucontrol

    # for screencasting
    # install prerequisities
    if [ -n "$NUMBAT" ]; then
      echo "Not installing obs-studio (not supported for Ubuntu 24.04)"
    else
      sudo add-apt-repository -y ppa:obsproject/obs-studio
      sudo apt-get -y install obs-studio screenkey
    fi

    # use in pdfpc to play videos
    sudo apt-get -y install gstreamer1.0-libav

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
