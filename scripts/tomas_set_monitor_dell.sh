PNAME=$( ps -p "$$" -o comm= )
SNAME=$( echo "$SHELL" | grep -Eo '[^/]+/?$' )
if [ "$PNAME" != "$SNAME" ]; then
  exec "$SHELL" "$0" "$@"
  exit "$?"
else
  source ~/."$SNAME"rc
fi

MONITOR=$(echo "LAB
PRESENTATION" | rofi -dmenu -p "Select setup:")

if [[ "$MONITOR" != "LAB" ]] && [[ "$MONITOR" != "PRESENTATION" ]]; then
  notify-send -u low -t 100 "Wrong choice!" -h string:x-canonical-private-synchronous:anything
  exit
fi

notify-send -u low -t 100 "Switching setup to $MONITOR" -h string:x-canonical-private-synchronous:anything

case "$MONITOR" in 
  LAB)
    ln -sf $GIT_PATH/linux-setup/miscellaneous/arandr_scripts/tomas/dell_lab.sh ~/.monitor.sh
    ;;
  PRESENTATION)
    ln -sf $GIT_PATH/linux-setup/miscellaneous/arandr_scripts/tomas/dell_presentation.sh ~/.monitor.sh

    # # uncomment for changing the colorscheme
    # /usr/bin/vim -u "$GIT_PATH/linux-setup/submodules/profile_manager/epigen/epigen.vimrc" -E -s -c "%g/.*PROFILES.*COLORSCHEME.*/norm ^/COLORSCHEMEciwCOLORSCHEME_LIGHT" -c "wqa" -- "$RCFILE"

    ;;
esac

source ~/.monitor.sh

# # uncomment for changing the colorscheme
# source ~/."$SNAME"rc
# cd "$GIT_PATH/linux-setup"
# ./backup_and_deploy.sh

# reload configuration for urxvt
xrdb ~/.Xresources

# refresh the output devices
xrandr --auto

# restart i3
i3-msg restart

notify-send -u low -t 100 "Setup switched" -h string:x-canonical-private-synchronous:anything
