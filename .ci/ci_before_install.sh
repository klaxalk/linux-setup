#!/bin/bash

set -e

sudo apt-get update -qq
sudo apt-get install dpkg git

echo "running the main install.sh"

./install.sh

echo "install part ended"
