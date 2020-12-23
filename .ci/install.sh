#!/bin/bash

set -e

sudo apt-get update -qq

distro=`lsb_release -r | awk '{ print $2 }'`
[ "$distro" = "18.04" ] && ROS_DISTRO="melodic"
[ "$distro" = "20.04" ] && ROS_DISTRO="noetic"

sudo apt-mark hold openssh-server

if [ "$distro" = "18.04" ]; then
  sudo apt-mark hold postgresql-10
fi

sudo apt -y upgrade --fix-missing

sudo apt-get install dpkg git

echo "running the main install.sh"

./install.sh --unattended

echo "install part ended"
