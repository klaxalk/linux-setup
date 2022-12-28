#!/usr/bin/python3
# -*- coding: utf-8 -*-

##########################################################################
# YouCompleteMe configuration for ROS                                    #
# Author: Gaël Ecorchard (2015)                                          #
# CoAuthor: Tomas Baca (2017)                                            #
# CoAuthor: Matouš Vrba (2020)                                           #
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
# Tested with Ubuntu 16.04 and Kinetic.                                  #
#                                                                        #
# License: CC0                                                           #
#                                                                        #
# TODO: make default flags have a lower priority than flags from cmake   #
#                                                                        #
##########################################################################

import sys
import os
from glob import glob
from clang import cindex
import rospkg
import re

ENV_WORKSPACES = 'ROS_WORKSPACES'

def GetWorkspacePath(filename):

    pkg_name = rospkg.get_package_name(filename)

    if not pkg_name:
        return ''

    paths = []
    if not ENV_WORKSPACES in os.environ:
        raise ValueError("The {} environmental variable is not set!".format(ENV_WORKSPACES))
    else:
        paths = os.environ[ENV_WORKSPACES]
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

def GetRosIncludePaths():
    """Return a list of potential include directories

    The directories are looked for in the ENV_WORKSPACES environment variable.
    """
    try:
        from rospkg import RosPack
    except ImportError:
        return []
    rospack = RosPack()
    includes = []

    paths = []
    if not ENV_WORKSPACES in os.environ:
        raise ValueError("The {} environmental variable is not set!".format(ENV_WORKSPACES))
    else:
        paths = os.environ[ENV_WORKSPACES]
    workspaces = paths.split()

    workspaces = paths.split()
    for workspace in workspaces:
        includes.append(os.path.expanduser(workspace) + '/devel/include')

    for p in rospack.list():
        if os.path.exists(rospack.get_path(p) + '/include'):
            includes.append(rospack.get_path(p) + '/include')
    for distribution in os.listdir('/opt/ros'):
        includes.append('/opt/ros/' + distribution + '/include')
    return includes

def GetRosIncludeFlags():
    includes = GetRosIncludePaths()
    flags = []
    for include in includes:
        flags.append('-isystem')
        flags.append(include)
    return flags

# These are the compilation flags that will be used in case there's no
# compilation database set (by default, one is not set).
# CHANGE THIS LIST OF FLAGS. YES, THIS IS THE DROID YOU HAVE BEEN LOOKING FOR.
# You can get CMake to generate the compilation_commands.json file for you by
# adding:
#   set(CMAKE_EXPORT_COMPILE_COMMANDS 1)
# to your CMakeLists.txt file or by once entering
#   catkin config --cmake-args '-DCMAKE_EXPORT_COMPILE_COMMANDS=ON'
# in your shell.

default_flags = [
    '-Wall',
    '-Wextra',
    # '-Werror',
    '-Wno-long-long',
    '-Wno-variadic-macros',
    '-fexceptions',
    '-DNDEBUG',
    '-DUSE_CLANG_COMPLETER',
    '-Qunused-arguments',
    '-std=c++17',
    # THIS IS IMPORTANT! Without a "-std=<something>" flag, clang won't know
    # which language to use when compiling headers. So it will guess. Badly. So
    # C++ headers will be compiled as C headers. You don't want that so ALWAYS
    # specify a "-std=<something>".
    # For a C project, you would set this to something like 'c99' instead of
    # '-std=c++11',
    # '-stdlib=libc++',
    # ...and the same thing goes for the magic -x option which specifies the
    # language that the files to be compiled are written in. This is mostly
    # relevant for c++ headers.
    # For a C project, you would set this to 'c' instead of 'c++'.
    '-x',
    'c++',
    '-I',
    '.',

    # include third party libraries
    # '-isystem',
    # '/some/path/include',

    # '-isystem',
    # '/usr/include/',
    # '-isystem',
    # '/usr/include/c++/v1/',
    # '-isystem',
    # '/usr/include/c++/v7/',
    # '-isystem',
    # '/usr/lib/',
]

flags = default_flags + GetRosIncludeFlags()

def GetCompilationDatabaseFolder(filename):
    """Return the directory potentially containing compilation_commands.json

    Return the absolute path to the folder (NOT the file!) containing the
    compile_commands.json file to use that instead of 'flags'. See here for
    more details: http://clang.llvm.org/docs/JSONCompilationDatabase.html.
    The compilation_commands.json for the given file is returned by getting
    the package the file belongs to.
    """

    filename = os.path.abspath(os.path.expanduser(os.path.expandvars(filename)))

    pkg_name = rospkg.get_package_name(filename)

    if not pkg_name:
        path = os.path.dirname(os.path.expanduser(filename))
        ccs = os.path.join(path, "compile_commands.json")
        if os.path.exists(ccs):
            return path

        path = os.path.join(path, "build")
        ccs = os.path.join(path, "compile_commands.json")
        if os.path.exists(ccs):
            return path

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

def GetDatabase(compilation_database_folder):
    if os.path.exists(compilation_database_folder):
        return cindex.CompilationDatabase.fromDirectory(compilation_database_folder)
    return None

SOURCE_EXTENSIONS = ['.cpp', '.cxx', '.cc', '.c', '.m', '.mm']

def DirectoryOfThisScript():
    return os.path.dirname(os.path.abspath(__file__))

def MakeRelativePathsInFlagsAbsolute(flags, working_directory):
    if not working_directory:
        return list(flags)
    new_flags = []
    make_next_absolute = False
    path_flags = ['-isystem', '-I', '-iquote', '--sysroot=']
    for flag in flags:
        new_flag = flag

        if make_next_absolute:
            make_next_absolute = False
            if not flag.startswith('/'):
                new_flag = os.path.join(working_directory, flag)

        for path_flag in path_flags:
            if flag == path_flag:
                make_next_absolute = True
                break

            if flag.startswith(path_flag):
                path = flag[len(path_flag):]
                new_flag = path_flag + os.path.join(working_directory, path)
                break

        if new_flag:
            new_flags.append(new_flag)
    return new_flags

def IsHeaderFile(filename):
    extension = os.path.splitext(filename)[1]
    return extension in ['.h', '.hxx', '.hpp', '.hh']

def GetCompilationInfoForHeaderSameDir(headerfile, database):
    """Return compile flags for src file with same base in the same directory
    """
    filename_no_ext = os.path.splitext(headerfile)[0]
    for extension in SOURCE_EXTENSIONS:
        replacement_file = filename_no_ext + extension
        if os.path.exists(replacement_file):
            compilation_info = database.GetCompilationInfoForFile(
                replacement_file)
            if compilation_info.compiler_flags_:
                return compilation_info
    return None

def GetCompilationInfoForHeaderRos(headerfile, database):
    """Return the compile flags for the corresponding src file in ROS
    Return the compile flags for the source file corresponding to the header
    file in the ROS where the header file is.
    TODO: Does not work, when the workspace is not sourced
    """
    with open("/tmp/ycm_debug.txt", "a") as file:
        pkg_name = rospkg.get_package_name(headerfile)
        if not pkg_name:
            return None
            file.write("Could not retrieve the package name")
        try:
            pkg_path = rospkg.RosPack().get_path(pkg_name)
        except rospkg.ResourceNotFound:
            return None
            file.write("Could not retrive the package path")
        filename_no_ext = os.path.splitext(headerfile)[0]
        hdr_basename_no_ext = os.path.basename(filename_no_ext)
        file.write("Header: {}\n".format(hdr_basename_no_ext))
        pattern = re.compile("^#include .*"+hdr_basename_no_ext+".*$")
        ros_include_pattern = re.compile("^#include .*ros.*$")
        for path, dirs, files in os.walk(pkg_path):
            for src_filename in files:
                for extension in SOURCE_EXTENSIONS:
                    if src_filename.endswith(extension):
                        src_basename_no_ext = os.path.splitext(src_filename)[0]
                        full_src_filename = path + os.path.sep + src_filename;
                        fh = open(full_src_filename)
                        file.write("{}".format(full_src_filename));
                        for line in fh:
                            if pattern.match(line):
                                file.write(" YES\n\n")
                                file.write("getting info for file: {}".format(path + os.path.sep + src_filename))
                                compilation_info = GetCompilationInfoForFile(path + os.path.sep + src_filename, database)
                                return compilation_info
                        file.write("\n")
            # where reaching here, we have not find a c file to the header, lets use any in the package, that uses ros
            file.write("didnt find suitable C file to the header, searching for some ROS c file\n\n")
            for src_filename in files:
                for extension in SOURCE_EXTENSIONS:
                    if src_filename.endswith(extension):
                        src_basename_no_ext = os.path.splitext(src_filename)[0]
                        full_src_filename = path + os.path.sep + src_filename;
                        fh = open(full_src_filename)
                        file.write("{}".format(full_src_filename));
                        for line in fh:
                            if ros_include_pattern.match(line):
                                file.write(" YES (ROS)\n\n")
                                compilation_info = database.GetCompilationInfoForFile(
                                    path + os.path.sep + src_filename)
                                if compilation_info.compiler_flags_:
                                    return compilation_info
                # if hdr_basename_no_ext != src_basename_no_ext:
                #     continue
                # for extension in SOURCE_EXTENSIONS:
                #     if src_filename.endswith(extension):
                #         compilation_info = database.GetCompilationInfoForFile(
                #             path + os.path.sep + src_filename)
                #         if compilation_info.compiler_flags_:
                #             file.write("-----")
                #             return compilation_info
        file.write("-----\n")
    return None

def GetCompilationInfoForFile(filename, database):
    # The compilation_commands.json file generated by CMake does not have
    # entries for header files. So we do our best by asking the db for flags
    # for a corresponding source file, if any. If one exists, the flags for
    # that file should be good enough.
    # Corresponding source file are looked for in the same package.
    if IsHeaderFile(filename):
        # Look in the same directory.
        compilation_info = GetCompilationInfoForHeaderSameDir(
            filename, database)
        if compilation_info:
            return compilation_info
        # Look in the package.
        compilation_info = GetCompilationInfoForHeaderRos(filename, database)
        if compilation_info:
            return compilation_info
        print("HEADER")

    cmds = database.getCompileCommands(filename)
    return cmds[0]
    # return database.GetCompilationInfoForFile(filename)

def Settings(**kwargs):
    filename = kwargs['filename']
    database = GetDatabase(GetCompilationDatabaseFolder(filename))
    if database:
        # Bear in mind that compilation_info.compiler_flags_ does NOT return a
        # python list, but a "list-like" StringVec object
        compilation_info = GetCompilationInfoForFile(filename, database)
        if compilation_info:
            final_flags = MakeRelativePathsInFlagsAbsolute(
                compilation_info.arguments,
                compilation_info.directory)
            # final_flags += flags
        else:
            final_flags = flags
    else:
        relative_to = DirectoryOfThisScript()
        final_flags = MakeRelativePathsInFlagsAbsolute(flags, relative_to)

    return {
        'flags': final_flags,
        'do_cache': True
    }

if __name__ == '__main__':
    fname = "~/hw_interface_workspace/src/mrs_uav_hw_interface/src/dummy_api.cpp"
    if len(sys.argv) > 1:
        fname = sys.argv[1]
    print(Settings(filename = fname))
