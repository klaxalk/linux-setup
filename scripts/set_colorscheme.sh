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

echo "$SNAME $PNAME"

RCFILE=~/."$SNAME"rc

COLOR_SCHEME=$( echo "DARK
LIGHT" | rofi -dmenu -p "Select colorscheme:")

if [ "$COLOR_SCHEME" != "DARK" ] && [ "$COLOR_SCHEME" != "LIGHT" ]; then
  notify-send -u low -t 100 "Wrong choice!" -h string:x-canonical-private-synchronous:anything
  exit
fi

notify-send -u low -t 100 "Setting colorscheme to $COLOR_SCHEME" -h string:x-canonical-private-synchronous:anything

# change the variable in bashrc
/usr/bin/vim -u "$GIT_PATH/linux-setup/submodules/profile_manager/epigen/epigen.vimrc" -E -s -c "%g/.*PROFILES.*COLORSCHEME.*/norm ^/COLORSCHEMEciwCOLORSCHEME_$COLOR_SCHEME" -c "wqa" -- "$RCFILE"

source $RCFILE

cd "$GIT_PATH/linux-setup"
./backup_and_deploy.sh

# reload configuration for urxvt
xrdb ~/.Xresources

# restart i3
i3-msg restart
