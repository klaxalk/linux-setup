#!/bin/bash

# get the path to this script
APP_PATH=`dirname "$0"`
APP_PATH=`( cd "$APP_PATH" && pwd )`

read -r -p $'\033[31mApply VIM settings? [y/n] \033[00m' response

response=${response,,} # tolower
if [[ $response =~ ^(yes|y| ) ]]; then

  toilet Setting up vim

  # compile vim from sources
  toilet Compiling vim
  cd $APP_PATH/../../submodules/vim
  ./configure --with-features=huge \
            --enable-multibyte \
            --enable-rubyinterp=yes \
            --enable-pythoninterp=yes \
            --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu \
            --enable-perlinterp=yes \
            --enable-luainterp=yes \
            --enable-gui=gtk2 --enable-cscope --prefix=/usr
  cd src
  make
  cd ../
  make VIMRUNTIMEDIR=/usr/share/vim/vim80
  sudo make install

  # symlink vim settings
  rm ~/.vimrc
  rm -rf ~/.vim
  ln -s $APP_PATH/dotvimrc ~/.vimrc
  ln -s $APP_PATH/dotvim ~/.vim

  # add variable for ctags sources into .bashrc
  num=`cat ~/.bashrc | grep "CTAGS_SOURCE_DIR" | wc -l`
  if [ "$num" -lt "1" ]; then
  
    echo "Adding CTAGS_SOURCE_DIR variable to .bashrc"
    # set bashrc
    echo '
# where should ctags look for sources to parse?
# -R dir1 -R dir2 ...
export CTAGS_SOURCE_DIR="-R ~/ros_workspace"' >> ~/.bashrc
 
  fi

  # add variable for ctags sources into .bashrc
  num=`cat ~/.bashrc | grep "CTAGS_ONCE_SOURCE_DIR" | wc -l`
  if [ "$num" -lt "1" ]; then
  
    echo "Adding CTAGS_ONCE_SOURCE_DIR variable to .bashrc"
    # set bashrc
    echo '
# where should ctags look for sources to parse?
# CTAGS FROM THOSE FILE WILL BE CREATED ONLY ONCE
# -R dir1 -R dir2 ...
export CTAGS_ONCE_SOURCE_DIR="-R /opt/ros/indigo/include"' >> ~/.bashrc
 
  fi

  # check whether ~/.my.vimrc file exists, copy mine version if does not 
  if [ ! -f ~/.my.vimrc ]; then
    echo "Creating ~/.my.vimrc file"
      
    cp $APP_PATH/dotmy.vimrc ~/.my.vimrc

  fi
  
  vim -E +PluginInstall +qall

  # set youcompleteme
  toilet Setting up youcompleteme
  cd ~/.vim/VundlePlugins/youcompleteme/
  ./install.py --all

fi
