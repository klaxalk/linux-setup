PNAME=$( ps -p "$$" -o comm= )
SNAME=$( echo "$SHELL" | grep -Eo '[^/]+/?$' )
if [ "$PNAME" != "$SNAME" ]; then
  exec "$SHELL" -i "$0" "$@"
  exit "$?"
else
  case $- in
    *i*) ;;
    *)
      exec "$SHELL" -i "$0" "$@"
      exit "$?"
      ;;
  esac
  source ~/."$SNAME"rc
fi

RCFILE=~/."$SNAME"rc

COLOR_SCHEME=$( echo "DARK
LIGHT" | rofi -dmenu -p "Select colorscheme:")

if [ "$COLOR_SCHEME" != "DARK" ] && [ "$COLOR_SCHEME" != "LIGHT" ]; then
  notify-send -u low -t 100 "Wrong choice!" -h string:x-canonical-private-synchronous:anything
  exit
fi

notify-send -u low -t 100 "Setting colorscheme to $COLOR_SCHEME" -h string:x-canonical-private-synchronous:anything

if [ -x "$(whereis nvim | awk '{print $2}')" ]; then
  VIM_BIN="$(whereis nvim | awk '{print $2}')"
  HEADLESS="--headless"
elif [ -x "$(whereis vim | awk '{print $2}')" ]; then
  VIM_BIN="$(whereis vim | awk '{print $2}')"
  HEADLESS=""
fi

# change the variable in bashrc
$VIM_BIN -u "$GIT_PATH/linux-setup/submodules/profile_manager/epigen/epigen.vimrc" $HEADLESS -E -s -c "%g/.*PROFILES.*COLORSCHEME.*/norm ^/COLORSCHEMEciwCOLORSCHEME_$COLOR_SCHEME" -c "wqa" -- "$RCFILE"

source $RCFILE

cd "$GIT_PATH/linux-setup"
./backup_and_deploy.sh

# reload configuration for urxvt
xrdb ~/.Xresources

# restart i3
i3-msg restart
