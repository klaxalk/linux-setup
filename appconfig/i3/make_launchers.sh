#!/bin/bash

# get the path to this script
APP_PATH=`dirname "$0"`
APP_PATH=`( cd "$APP_PATH" && pwd )`

cd $APP_PATH/../../scripts/

./makeLauncher.sh "rviz" "RViz"
./makeLauncher.sh "rosrun plotjuggler PlotJuggler" "PlotJuggler"
./makeLauncher.sh "rqt_image_view" "RQt Image Viewer"
./makeLauncher.sh "rosrun rqt_tf_tree rqt_tf_tree" "RQt TF Tree Viewer"
./makeLauncher.sh "rqt" "RQt Menu"
