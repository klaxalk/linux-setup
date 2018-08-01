PNAME=$( ps -p "$$" -o comm= )
SNAME=$( echo "$SHELL" | grep -Eo '[^/]+/?$' )
if [ "$PNAME" != "$SNAME" ]; then
  command "$SNAME" "$0" "$@"
  exit "$?"
fi

MONITOR=$( echo "CLASSIC
FHD_EXTERNAL" | rofi -dmenu -p "Select monitor:")

if [[ "$MONITOR" != "CLASSIC" ]] && [[ "$MONITOR" != "FHD_EXTERNAL" ]]; then
  notify-send -u low -t 100 "Wrong choice!" -h string:x-canonical-private-synchronous:anything
  exit
fi

notify-send -u low -t 100 "Switching monitor to $MONITOR" -h string:x-canonical-private-synchronous:anything

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
  *CLASSIC*)
    ln -sf $GIT_PATH/linux-setup/miscellaneous/arandr_scripts/vojta/classic.sh ~/.monitor.sh
    ;;
  *FHD_EXTERNAL*)
    ln -sf $GIT_PATH/linux-setup/miscellaneous/arandr_scripts/vojta/fhd_external.sh ~/.monitor.sh
    # change the variable in bashrc
    $VIM_BIN $HEADLESS -u "$GIT_PATH/linux-setup/submodules/profile_manager/epigen/epigen.vimrc" -E -s -c "%g/.*PROFILES.*COLORSCHEME.*/norm ^/COLORSCHEMEciwCOLORSCHEME_LIGHT" -c "wqa" -- "$RCFILE"
    ;;
esac

source ~/.monitor.sh

source "$RCFILE"

cd "$GIT_PATH/linux-setup"
./backup_and_deploy.sh

# reload configuration for urxvt
xrdb ~/.Xresources

# refresh the output devices
xrandr --auto

# restart i3
i3-msg restart

notify-send -u low -t 100 "Monitor switched" -h string:x-canonical-private-synchronous:anything
