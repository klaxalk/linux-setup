# - make the script run in bash/zsh while having its dotfile sourced
# - this is important when there are variables exported, which might
#   be used by this script
PNAME=$( ps -p "$$" -o comm= )
SNAME=$( echo "$SHELL" | grep -Eo '[^/]+/?$' )
if [ "$PNAME" != "$SNAME" ]; then
  exec "$SHELL" "$0" "$@"
  exit "$?"
else
  source ~/."$SNAME"rc
fi

./submodules/dotprofiler/dotprofiler.sh deploy ./appconfig/dotprofiler/file_list.txt
