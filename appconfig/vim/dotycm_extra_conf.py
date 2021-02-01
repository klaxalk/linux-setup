#!/usr/bin/python3
# -*- coding: utf-8 -*-

##########################################################################
# YouCompleteMe configuration for ROS                                    #
# Author: Gaël Ecorchard (2015)                                          #
# CoAuthor: Tomas Baca (2017)                                            #
# CoAuthor: Matouš Vrba (2020) - edited for clangd                       #
#                                                                        #
# The file requires the definition of the $ROS_WORKSPACES variable in    #
# your shell. The variable should be a string with paths to all your     #
# workspaces separated by a space.                                       #
#                                                                        #
# e.g. export ROS_WORKPSACES="~/ROS_WORKSPACES ~/test_workspace"         #
#                                                                        #
# Name this file .ycm_extra_conf.py and place it to a folder in which    #
# you keep your ROS workspaces (or rather your source codes since vim    #
# searches back from editted source file thgrough the file structure and #
# looks for this file. My usecase is: I keep all my sources in ~/git/    #
# and link them to their respective ROS workspaces in my home. So I      #
# placed it to my home folder.                                           #
#                                                                        #
# Tested with Ubuntu 18.04 and Melodic.                                  #
#                                                                        #
# License: CC0                                                           #
#                                                                        #
##########################################################################

import sys
import os
from glob import glob

def GetWorkspacePath(filename):

    try:
        import rospkg
    except ImportError:
        return ''
    pkg_name = rospkg.get_package_name(filename)

    if not pkg_name:
        return ''

    # get the content of $ROS_WORKSPACES variable
    # and create an array out of it
    paths = os.path.expandvars('$ROS_WORKSPACES')
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

    return 0

def GetCompilationDatabaseFolder(filename):
    """Return the directory potentially containing compilation_commands.json

    Return the absolute path to the folder (NOT the file!) containing the
    compile_commands.json file to use that instead of 'flags'. See here for
    more details: http://clang.llvm.org/docs/JSONCompilationDatabase.html.
    The compilation_commands.json for the given file is returned by getting
    the package the file belongs to.
    """
    try:
        import rospkg
    except ImportError:
        return ''
    pkg_name = rospkg.get_package_name(filename)

    if not pkg_name:
        return ''

    workspace_path = GetWorkspacePath(filename)

    if not workspace_path:
        return ''

    dir = (workspace_path +
           os.path.sep +
           'build' +
           os.path.sep +
           pkg_name)

    return dir

def Settings(**kwargs):
    filename = kwargs['filename']
    language = kwargs['language']
    if language == 'cfamily':
      return {
        'ls': {
          'compilationDatabasePath': GetCompilationDatabaseFolder(filename)
        }
      }
    return None

if __name__ == '__main__':
    print(Settings(filename = sys.argv[1], language = "cfamily"))
