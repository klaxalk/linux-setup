" vim-ros config

let g:ros_make='current'
let g:ros_build_system='catkin-tools'

au BufNewFile,BufRead *.launch set filetype=roslaunch.xml

python3 << EOS
try:
   import rospkg
   import vim
except ImportError:
   vim.command("let is_ros='N/A'")
if rospkg.get_package_name(vim.eval("expand('%:p')")):
   vim.command("let is_ros='true'")
   vim.command("let &makeprg='catkin build "+rospkg.get_package_name(vim.eval("expand('%:p')"))+"'")
else:
   vim.command("let is_ros='false'")
EOS

if is_ros == "true"
  set efm=%f:%l:%c:\ error:%m
endif
