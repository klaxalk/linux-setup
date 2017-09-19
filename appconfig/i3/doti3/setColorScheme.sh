#!/bin/bash

files=(
  "~/.i3/config"
  "~/.i3/i3blocks.conf"
  "~/.my.vimrc"
  "~/.Xresources"
  "~/.tmux.conf"
  "~/.vimrc"
  "~/git/linux-setup/appconfig/vim/dotvim/pluginconfig/vim-airline.vim"
  "~/git/linux-setup/appconfig/i3/i3blocks/wifi"
  "~/git/linux-setup/appconfig/i3/i3blocks/battery"
  "~/.config/zathura/zathurarc"
)

#{ setColorScheme()
setColorScheme() {

  # comment all color_scheme-specific lines (single line)
  /usr/bin/vim $1 -c '%g/^.* COLOR_SCHEME ACTIVE\s*$/norm gcc$Bd$' -c "wqa"

  # uncomment lines with specific color scheme (single line)
  /usr/bin/vim $1 -c "%g/^.*$2 COLOR_SCHEME\s*$/norm gcc\$Bea ACTIVE"  -c "wqa"

  # comment all color_scheme-specific lines (multi line)
  /usr/bin/vim $1 -c '%g/.*COLOR_SCHEME ACTIVE\s\+{\s*/norm f{Bdaw^f{gci{' -c "wqa"

  # uncomment lines with specific color scheme (multi line)
  /usr/bin/vim $1 -c "%g/^.*$2 COLOR_SCHEME\s\+{\s*$/norm f{iACTIVE jk^f{gci{" -c "wqa"

  echo "Switched to $2 in the file: $1"
}
#}

COLOR_SCHEME="$1"

for ((i=0; i < ${#files[*]}; i++));
do
  eval path=${files[$i]}
  setColorScheme $path "$COLOR_SCHEME"
done

# reload configuration for urxvt
xrdb ~/.Xresources

i3-msg restart

echo "Done"

sleep 1
