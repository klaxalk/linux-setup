" vim-ros config

let g:ros_make='current'
let g:ros_build_system='catkin-tools'

au BufNewFile,BufRead *.launch set filetype=roslaunch.xml

" enable spell checking for message and service files
au BufNewFile,BufRead *.msg setlocal spell spelllang=en_us
au BufNewFile,BufRead *.srv setlocal spell spelllang=en_us

function! PrepRos()
  python3 << EOS
try:

    import rospkg
    import os
    from glob import glob
    import vim

    def GetWorkspacePath(filename):

        try:
            pkg_name = rospkg.get_package_name(filename)
        except:
            return ''

        if not pkg_name:
            return ''

        # get the content of $ROS_WORKSPACE variable
        # and create an array out of it
        paths =  os.path.expandvars('$ROS_WORKSPACES')
        workspaces = paths.split()

        # iterate over all workspaces
        for single_workspace in workspaces:

            # get the full path to the workspace
            workspace_path = os.path.expanduser(single_workspace)

            # get all ros packages built in workspace's build directory
            paths = glob(workspace_path + "/build/*")

            # iterate over all the packages built in the workspace
            for package_path in paths:

                # test whether the package, to which "filename" belongs to, is in the workspace
                if package_path.endswith(pkg_name):

                    # if it is, return path to its workspace
                    return workspace_path

        return ''

    pkgname = ""
    try:
        pkgname = rospkg.get_package_name(vim.eval("expand('%:p')"))
    except:
        pass
    if isinstance(pkgname, str):
        workspace_path = GetWorkspacePath(vim.eval("expand('%:p')"))
        r = rospkg.RosPack()
        vim.command("let is_ros='true'")
        # make_cmd="let &makeprg='cd "+workspace_path+"; catkin build "+pkgname+" --no-color --cmake-args -DCMAKE_CXX_FLAGS=-fno-diagnostics-color'"
        make_cmd="let &makeprg='cd "+workspace_path+"; catkin build "+pkgname+" --no-color'"
        # print(make_cmd)
        vim.command(make_cmd)
    else:
        vim.command("let is_ros='false'")
except ImportError:
    vim.command("let is_ros='N/A'")
EOS

  if exists("is_ros")
    if is_ros == "true"
      set efm=%f:%l:%c:\ error:%m
    endif
  endif
endfunction

" vim.command("let &makeprg='cd "+workspace_path+"; catkin build "+pkgname+" 2>&1\| sed -e /width/d'")

au BufNewFile,BufRead,BufEnter *.cpp,*h,*hpp,*.launch,*.yaml call PrepRos()
