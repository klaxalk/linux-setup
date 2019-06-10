#!/bin/bash

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
    [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall playerctl to control music from terminal (from debian repos)? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    toilet Setting up playerctl

    wget http://ftp.nl.debian.org/debian/pool/main/p/playerctl/libplayerctl2_2.0.1-1_amd64.deb -O "$APP_PATH/libplayerctl2_2.0.1-1_amd64.deb"
    wget http://ftp.nl.debian.org/debian/pool/main/p/playerctl/playerctl_2.0.1-1_amd64.deb -O "$APP_PATH/playerctl_2.0.1-1_amd64.deb"
    sudo dpkg -i "$APP_PATH/libplayerctl2_2.0.1-1_amd64.deb" "$APP_PATH/playerctl_2.0.1-1_amd64.deb"
    rm "$APP_PATH/libplayerctl2_2.0.1-1_amd64.deb" "$APP_PATH/playerctl_2.0.1-1_amd64.deb"

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
