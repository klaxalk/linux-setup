PNAME=$( ps -p "$$" -o comm= )
SNAME=$( echo "$SHELL" | grep -Eo '[^/]+/?$' )
if [ "$PNAME" != "$SNAME" ]; then
  exec "$SHELL" "$0" "$@"
  exit "$?"
else
  source ~/."$SNAME"rc
fi

# THE NAME OF THE PROFILE SHOULD REFLECT THE NAME OF THE ARANDR FILE LATER LINKED

MONITOR=$(echo "STANDALONE
LAB" | rofi -i -dmenu -p "Select setup:")

if [[ "$MONITOR" != "STANDALONE" ]] && [[ "$MONITOR" != "LAB" ]]; then
  notify-send -u low -t 2000 "Wrong choice!" -h string:x-canonical-private-synchronous:anything
  exit
fi

o

notify-send -u low -t 2000 "Switching setup to $MONITOR" -h string:x-canonical-private-synchronous:anything

# refresh the output devices
xrandr --auto

VIM_BIN="$(whereis nvim | awk '{print $2}')"
HEADLESS="--headless"

# link the arandr file
MONITOR_LOWERCASE=$(echo $MONITOR | awk '{print tolower($0)}')
ln -sf $GIT_PATH/linux-setup/miscellaneous/arandr_scripts/tomas/asus_$MONITOR_LOWERCASE.sh ~/.monitor.sh

# change the variable in bashrc
$VIM_BIN $HEADLESS -u "$GIT_PATH/linux-setup/submodules/profile_manager/epigen/epigen.vimrc" -E -s -c "%g/.*PROFILES.*MONITOR.*/norm ^/MONITORciwMONITOR_$MONITOR" -c "wqa" -- ~/."$SNAME"rc

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

notify-send -u low -t 2000 "Setup switched" -h string:x-canonical-private-synchronous:anything
