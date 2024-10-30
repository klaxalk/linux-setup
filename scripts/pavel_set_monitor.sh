PNAME=$( ps -p "$$" -o comm= )
SNAME=$( echo "$SHELL" | grep -Eo '[^/]+/?$' )
if [ "$PNAME" != "$SNAME" ]; then
  exec "$SHELL" "$0" "$@"
  exit "$?"
else
  source ~/."$SNAME"rc
fi

if [[ $# -gt 0 ]]; then
  if [[ "$1" != "HP" ]] && [[ "$1" != "LENOVO" ]] && [[ "$1" != "WORKSTATION" ]]; then
    notify-send -u low -t 1500 "Supported models: HP, LENOVO, WORKSTATION" -h string:x-canonical-private-synchronous:anything
    exit
  fi
else
    notify-send -u low -t 1500 "PC model required. Supported models: HP, LENOVO, WORKSTATION" -h string:x-canonical-private-synchronous:anything
    exit
fi

# THE NAME OF THE PROFILE SHOULD REFLECT THE NAME OF THE ARANDR FILE LATER LINKED

MONITOR=$(echo "MRS_LAB
STANDALONE
SECOND_MONITOR
F4F" | rofi -i -dmenu -p "Select setup:")

if [[ "$MONITOR" != "MRS_LAB" ]] &&
   [[ "$MONITOR" != "STANDALONE" ]] &&
   [[ "$MONITOR" != "F4F" ]] &&
   [[ "$MONITOR" != "SECOND_MONITOR" ]]; then
  notify-send -u low -t 1500 "Wrong choice!" -h string:x-canonical-private-synchronous:anything
  exit
fi

notify-send -u low -t 1500 "Switching setup to $MONITOR" -h string:x-canonical-private-synchronous:anything

# refresh the output devices
xrandr --auto

if [ -x "$(whereis nvim | awk '{print $2}')" ]; then
  VIM_BIN="$(whereis nvim | awk '{print $2}')"
  HEADLESS="--headless"
elif [ -x "$(whereis vim | awk '{print $2}')" ]; then
  VIM_BIN="$(whereis vim | awk '{print $2}')"
  HEADLESS=""
fi

MODEL_PREFIX_LOWERCASE="$(echo $1 | awk '{print tolower($0)}')_"

# link the arandr file
MONITOR_LOWERCASE=$(echo $MONITOR | awk '{print tolower($0)}')
ln -sf $GIT_PATH/linux-setup/miscellaneous/arandr_scripts/pavel/$MODEL_PREFIX_LOWERCASE$MONITOR_LOWERCASE.sh ~/.monitor.sh

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

notify-send -u low -t 1500 "Setup switched" -h string:x-canonical-private-synchronous:anything
