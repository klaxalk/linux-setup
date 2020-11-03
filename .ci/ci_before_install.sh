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

# the "gce-compute-image-packages" package often freezes the installation
# the installation freezes when it tries to manage some systemd services
((sleep 90 && (sudo systemctl stop google-instance-setup.service && echo "gce service stoped" || echo "gce service not stoped")) & (sudo timeout 120 apt-get -y install gce-compute-image-packages)) || echo "\e[1;31mInstallation of gce-compute-image-packages failed\e[0m"

sudo apt -y upgrade --fix-missing

sudo apt-get install dpkg git

echo "running the main install.sh"

./install.sh --unattended

echo "install part ended"
