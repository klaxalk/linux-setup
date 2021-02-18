#!/bin/bash

set -e

distro=`lsb_release -r | awk '{ print $2 }'`
[ "$distro" = "18.04" ] && ROS_DISTRO="melodic"
[ "$distro" = "20.04" ] && ROS_DISTRO="noetic"

sudo apt-get update -qq
sudo apt-mark hold openssh-server # the installation might get stuck while upgrading this
sudo apt-mark hold msodbcsql17 mssql-tools # microsoft wants to manually accept EULA while upgrading this

if [ "$distro" = "18.04" ]; then
  sudo apt-mark hold postgresql-10
fi

sudo apt -y upgrade --fix-missing

sudo apt-get install dpkg git

echo "running the main install.sh"

./install.sh --unattended

echo "install part ended"
