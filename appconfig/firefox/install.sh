#!/bin/bash

set -e

trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "$0: \"${last_command}\" command failed with exit code $?"' ERR

# get the path to this script
APP_PATH=`dirname "$0"`
APP_PATH=`( cd "$APP_PATH" && pwd )`

unattended=0
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
    [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall snap-less Firefox? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    echo "Adding the official mozilla PPA repository"
    sudo add-apt-repository ppa:mozillateam/ppa

    echo "Setting priority for installing Firefox from the PPA"
    echo '
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001

Package: firefox
Pin: version 1:1snap*
Pin-Priority: -1
    ' | sudo tee /etc/apt/preferences.d/mozilla-firefox

    echo "Removing the snap version of Firefox"
    # sudo rm -f /etc/apparmor.d/usr.bin.firefox 
    # sudo rm -f /etc/apparmor.d/local/usr.bin.firefox

    # sudo systemctl stop var-snap-firefox-common-host\\x2dhunspell.mount
    # sudo systemctl disable var-snap-firefox-common-host\\x2dhunspell.mount
    sudo snap remove firefox
    sudo apt-get remove -y firefox

    sudo apt-get install -y firefox

    echo "Disabling unattended upgrades to avoid reinstalling the snap Firefox"
    echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' | sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi

done
