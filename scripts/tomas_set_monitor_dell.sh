PNAME=$( ps -p "$$" -o comm= )
SNAME=$( echo "$SHELL" | grep -Eo '[^/]+/?$' )
if [ "$PNAME" != "$SNAME" ]; then
  exec "$SHELL" "$0" "$@"
  exit "$?"
else
  source ~/."$SNAME"rc
fi

# refresh the output devices
xrandr --auto

MONITOR=$(echo "LAB
PRESENTATION
STANDALONE" | rofi -dmenu -p "Select setup:")

if [[ "$MONITOR" != "LAB" ]] && [[ "$MONITOR" != "PRESENTATION" ]] && [[ "$MONITOR" != "STANDALONE" ]]; then
  notify-send -u low -t 100 "Wrong choice!" -h string:x-canonical-private-synchronous:anything
  exit
fi

notify-send -u low -t 100 "Switching setup to $MONITOR" -h string:x-canonical-private-synchronous:anything

case "$SHELL" in 
  *bash*)
    RCFILE="$HOME/.bashrc"
    ;;
  *zsh*)
    RCFILE="$HOME/.zshrc"
    ;;
esac

if [ -x "$(whereis nvim | awk '{print $2}')" ]; then
  VIM_BIN="$(whereis nvim | awk '{print $2}')"
  HEADLESS="--headless"
elif [ -x "$(whereis vim | awk '{print $2}')" ]; then
  VIM_BIN="$(whereis vim | awk '{print $2}')"
  HEADLESS=""
fi

case "$MONITOR" in 
  LAB)
    ln -sf $GIT_PATH/linux-setup/miscellaneous/arandr_scripts/tomas/dell_lab.sh ~/.monitor.sh
    $VIM_BIN $HEADLESS -u "$GIT_PATH/linux-setup/submodules/profile_manager/epigen/epigen.vimrc" -E -s -c "%g/.*PROFILES.*MONITOR.*/norm ^/MONITORciwMONITOR_EXTERNAL" -c "wqa" -- "$RCFILE"
    ;;
  PRESENTATION)
    ln -sf $GIT_PATH/linux-setup/miscellaneous/arandr_scripts/tomas/dell_presentation.sh ~/.monitor.sh
    $VIM_BIN $HEADLESS -u "$GIT_PATH/linux-setup/submodules/profile_manager/epigen/epigen.vimrc" -E -s -c "%g/.*PROFILES.*MONITOR.*/norm ^/MONITORciwMONITOR_EXTERNAL" -c "wqa" -- "$RCFILE"
    ;;
  STANDALONE)
    $VIM_BIN $HEADLESS -u "$GIT_PATH/linux-setup/submodules/profile_manager/epigen/epigen.vimrc" -E -s -c "%g/.*PROFILES.*MONITOR.*/norm ^/MONITORciwMONITOR_STANDALONE" -c "wqa" -- "$RCFILE"
    ;;
esac

source ~/.monitor.sh

# uncomment for changing the colorscheme
source ~/."$SNAME"rc
cd "$GIT_PATH/linux-setup"
./backup_and_deploy.sh

# reload configuration for urxvt
xrdb ~/.Xresources

# refresh the output devices
xrandr --auto

# restart i3
i3-msg restart

notify-send -u low -t 100 "Setup switched" -h string:x-canonical-private-synchronous:anything
