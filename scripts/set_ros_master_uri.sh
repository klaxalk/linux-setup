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

if [ -x "$(whereis nvim | awk '{print $2}')" ]; then
  VIM_BIN="$(whereis nvim | awk '{print $2}')"
  HEADLESS="--headless"
elif [ -x "$(whereis vim | awk '{print $2}')" ]; then
  VIM_BIN="$(whereis vim | awk '{print $2}')"
  HEADLESS=""
fi

# the input
NEW_URI=$1

# change the variable in bashrc
$VIM_BIN -u "$GIT_PATH/linux-setup/submodules/profile_manager/epigen/epigen.vimrc" $HEADLESS -E -s -c "%g/^\s*export ROS_MASTER_URI.*/norm ^2f/lct:$NEW_URI" -c "wqa" -- "$RCFILE"

source $RCFILE

echo "my new ROS_MASTER_URI=$ROS_MASTER_URI"
