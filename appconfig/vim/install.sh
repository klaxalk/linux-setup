#!/bin/bash

# symlink vim settings
rm ~/.vimrc
rm ~/.vim
ln -s $MY_PATH/dotvimrc ~/.vimrc
ln -s $MY_PATH/dotvim ~/.vim
