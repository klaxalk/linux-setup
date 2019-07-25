#/bin/bash
if [ "$#" -ne 2 ]; then
  mkdir -p scripts
  echo "Input command for the new launcher: "
  read c_command
  echo "Input name for the new launcher: "
  read c_name
else
  c_command=$1
  c_name=$2
fi
c_fname=`echo $c_name | tr ' ' '_'`
echo "#/bin/bash\n$HOME/git/linux-setup/appconfig/i3/doti3/detacher.sh \"$c_command\"" > $HOME/scripts/$c_fname.sh
chmod +x $HOME/scripts/$c_fname.sh
echo "[Desktop Entry]\nType=Application\nTerminal=false\nName=c_name\nExec=$HOME/scripts/$c_fname.sh\nName=$c_name" > $HOME/.local/share/applications/$c_fname.desktop 
