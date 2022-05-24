#!/bin/bash

set -e

trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "$0: \"${last_command}\" command failed with exit code $?"' ERR

# get the path to this script
APP_PATH=`dirname "$0"`
APP_PATH=`( cd "$APP_PATH" && pwd )`

cd $APP_PATH/../../scripts/

./makeLauncher.sh "rviz" "Rviz"
./makeLauncher.sh "rosrun plotjuggler plotjuggler" "PlotJuggler"
./makeLauncher.sh "rqt_image_view" "rqt Image Viewer"
./makeLauncher.sh "rosrun rqt_reconfigure rqt_reconfigure" "rqt Dynamic Reconfigurator"
./makeLauncher.sh "rosrun rqt_tf_tree rqt_tf_tree" "rqt TF Tree Viewer"
./makeLauncher.sh "rqt" "rqt Menu"
./makeLauncher.sh "roslaunch rqt_bag rqt_bag.launch" "rqt bag"
