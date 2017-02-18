#!/bin/bash
# shell script to prepend i3status with more stuff

i3status -c ~/.i3/i3status.conf | while :
do
        read line

        source /home/klaxalk/.i3/env_variables.txt

        echo '$ROS_IP='"$ROS_IP"' | $UAV_NAME='"$UAV_NAME $line" || exit 1
done
