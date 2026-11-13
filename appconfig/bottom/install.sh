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
    [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall bottom (btm)? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    echo "$0: Installing bottom"

    sudo apt-get -y install curl

    deb_arch=`dpkg --print-architecture`

    # find the .deb of the latest release for this architecture
    url=`curl -fsSL https://api.github.com/repos/ClementTsang/bottom/releases/latest | grep -o "https://[^\"]*/bottom_[^\"/]*_${deb_arch}\.deb" | head -n 1`

    if [ -z "$url" ]; then
      echo "$0: could not find a bottom .deb for architecture '$deb_arch'"
      exit 1
    fi

    tmp_dir=`mktemp -d`
    curl -fsSL -o $tmp_dir/bottom.deb "$url"
    sudo apt-get -y install $tmp_dir/bottom.deb
    rm -rf $tmp_dir

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
