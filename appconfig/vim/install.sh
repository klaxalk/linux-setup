#!/bin/bash

# get the path to this script
APP_PATH=`dirname "$0"`
APP_PATH=`( cd "$APP_PATH" && pwd )`

while true; do
  [[ -t 0 ]] && { read -t 10 -n 2 -p $'\033[31mInstall vim? [y/n] \033[00m' resp || resp="y" ; }
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    toilet Setting up vim

    sudo apt-get -y install libncurses5-dev libgnome2-dev libgnomeui-dev libgtk2.0-dev libatk1.0-dev libbonoboui2-dev libcairo2-dev libx11-dev libxpm-dev libxt-dev

    # compile vim from sources
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
      export CTAGS_SOURCE_DIR="-R ~/mrs_workspace"' >> ~/.bashrc

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
      export CTAGS_ONCE_SOURCE_DIR="-R /opt/ros/kinetic/include"' >> ~/.bashrc

    fi

    # check whether ~/.my.vimrc file exists, copy mine version if does not 
    if [ ! -f ~/.my.vimrc ]; then
      echo "Creating ~/.my.vimrc file"

      cp $APP_PATH/dotmy.vimrc ~/.my.vimrc

    fi

    vim -E +PluginInstall +qall
    vim -E +PluginClean +qall

    while true; do
      [[ -t 0 ]] && { read -t 10 -n 2 -p $'\033[31mCompile YouCompleteMe? [y/n] \033[00m' resp || resp="y" ; }
      response=`echo $resp | sed -r 's/(.*)$/\1=/'`

      if [[ $response =~ ^(y|Y)=$ ]]
      then

        # set youcompleteme
        toilet Setting up youcompleteme

        cd ~/.vim/VundlePlugins/youcompleteme/
        ./install.py --all

        # link .ycm_extra_conf.py
        ln -s $APP_PATH/dotycm_extra_conf.py ~/.ycm_extra_conf.py

        break
      elif [[ $response =~ ^(n|N)=$ ]]
      then
        break
      else
        echo " What? \"$resp\" is not a correct answer. Try y+Enter."
      fi
    done

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
