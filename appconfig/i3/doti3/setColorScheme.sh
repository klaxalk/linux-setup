#!/bin/bash

COLOR_SCHEME="$1"

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

  echo "Switched to $2 in $1"
}
#}

setColorScheme ~/.i3/config $COLOR_SCHEME
setColorScheme ~/.i3/i3blocks.conf $COLOR_SCHEME
setColorScheme ~/.my.vimrc $COLOR_SCHEME
setColorScheme ~/.Xresources $COLOR_SCHEME
setColorScheme ~/.tmux.conf $COLOR_SCHEME
setColorScheme ~/git/linux-setup/appconfig/i3/i3blocks/wifi $COLOR_SCHEME
setColorScheme ~/git/linux-setup/appconfig/i3/i3blocks/battery $COLOR_SCHEME

# reload configuration for urxvt
xrdb ~/.Xresources

i3-msg restart

echo "Done"

sleep 1
