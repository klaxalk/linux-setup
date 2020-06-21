#!/bin/bash

set -e

sudo apt-get update -qq
sudo apt-mark hold openssh-server
sudo apt -y upgrade --fix-missing
sudo apt-get install dpkg git

echo "running the main install.sh"

./install.sh

echo "install part ended"
