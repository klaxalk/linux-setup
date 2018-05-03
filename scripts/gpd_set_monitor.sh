PNAME=$( ps -p "$$" -o comm= )
SNAME=$( echo "$SHELL" | grep -Eo '[^/]+/?$' )
if [ "$PNAME" != "$SNAME" ]; then
  command "$SNAME" "$0" "$@"
  exit "$?"
fi

MONITOR=$( echo "STANDALONE
EXTERNAL" | rofi -dmenu -p "Select monitor:")

if [[ "$MONITOR" != "STANDALONE" ]] && [[ "$MONITOR" != "EXTERNAL" ]]; then
  notify-send -u low -t 100 "Wrong choice!" -h string:x-canonical-private-synchronous:anything
  exit
fi

notify-send -u low -t 100 "Switching monitor to $MONITOR" -h string:x-canonical-private-synchronous:anything

# refresh the output devices
xrandr --auto

case "$SHELL" in 
  *bash*)
    RCFILE="$HOME/.bashrc"
    ;;
  *zsh*)
    RCFILE="$HOME/.zshrc"
    ;;
esac

# change the variable in bashrc
/usr/bin/vim -u "$GIT_PATH/linux-setup/submodules/dotprofiler/epigen/epigen.vimrc" -E -s -c "%g/.*PROFILER.*MONITOR.*/norm ^/MONITORciwMONITOR_$MONITOR" -c "wqa" -- "$RCFILE"

source "$RCFILE"

cd "$GIT_PATH/linux-setup"
./backup_and_deploy.sh

# reload configuration for urxvt
xrdb ~/.Xresources

# restart i3
i3-msg restart

notify-send -u low -t 100 "Monitor switched" -h string:x-canonical-private-synchronous:anything
