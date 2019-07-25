#!/usr/bin/zsh

script_path=../../scripts
if [ $# -gt 2 ]; then
  script_path=$1;
fi

$script_path/makeLauncher.sh "rviz" "RViz"
$script_path/makeLauncher.sh "rosrun plotjuggler PlotJuggler" "PlotJuggler"
$script_path/makeLauncher.sh "rqt_image_view" "RQt Image Viewer"
$script_path/makeLauncher.sh "rosrun rqt_reconfigure rqt_reconfigure" "RQt Dynamic Reconfigurator"
$script_path/makeLauncher.sh "rosrun rqt_tf_tree rqt_tf_tree" "RQt TF Tree Viewer"
$script_path/makeLauncher.sh "rqt" "RQt Menu"
