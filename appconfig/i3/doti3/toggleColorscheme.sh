#!/bin/bash

# toggle colors in i3 config
/usr/bin/vim --servername dog --cmd 'let g:normal_mode=1' ~/.i3/config -c "/LIGHT_THEME" -c ":norm gcip" -c "/DARK_THEME" -c ":norm gcip" -c "wqa"
notify-send -u low -i mouse "25%"

# toggle colors in i3 blocks
/usr/bin/vim --servername dog --cmd 'let g:normal_mode=1' ~/.i3/i3blocks.conf -c "%g/LIGHT_THEME/norm gcc" -c "%g/DARK_THEME/norm gcc" -c "wqa"
notify-send -u low -i mouse "50%"

# toggle colors vim
/usr/bin/vim --servername dog --cmd 'let g:normal_mode=1' ~/.my.vimrc -c "%g/raggi/norm gcc" -c "%g/jellybeans/norm gcc" -c "wqa"
notify-send -u low -i mouse "75%"

# toggle colors urxvt
/usr/bin/vim --servername dog --cmd 'let g:normal_mode=1' ~/.Xresources -c "%g/DARK_THEME/norm jgcc" -c "%g/LIGHT_THEME/norm jgcc" -c "wqa"
notify-send -u low -i mouse "100%"

# reload configuration for urxvt
xrdb ~/.Xresources

notify-send -u low -i mouse "Colorscheme toggled"
i3-msg reload
i3-msg restart
