#!/bin/bash

set -e

sudo apt-get update -qq
sudo apt-get install dpkg git
sudo apt-get upgrade -qq

echo "running the main install.sh"

./install.sh

echo "install part ended"
