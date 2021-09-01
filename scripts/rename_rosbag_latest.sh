#!/bin/bash

suffix="_RENAMED"
if [ $# -gt 0 ]; then
  suffix="_$1"
fi

# find physical name of the latest rosbag folder
path=`readlink -f ~/bag_files/latest`
if [ $? -ne 0 ]; then
  echo "Could not find link ~/bag_files/latest"  1>&2
  exit 1
fi

# go to the parent folder and rename the rosbag folder
mv "$path" "$path$suffix"
