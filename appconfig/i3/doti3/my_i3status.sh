#!/bin/sh
# shell script to prepend i3status with more stuff

source ~/.bashrc

i3status -c ~/.i3/i3status.conf | while :
do
        read line
        echo '$ROS_IP='"$ROS_IP"' | $UAV_NAME='"$UAV_NAME $line" || exit 1
done
