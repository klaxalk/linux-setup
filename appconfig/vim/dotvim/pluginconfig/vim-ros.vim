" vim-ros config

let g:ros_make='current'
let g:ros_build_system='catkin-tools'

au BufNewFile,BufRead *.launch set filetype=roslaunch.xml
