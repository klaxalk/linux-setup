#!/bin/bash
if [ "$#" -ne 2 ]; then
  echo "Input command for the new launcher: "
  read c_command
  echo "Input name for the new launcher: "
  read c_name
else
  c_command=$1
  c_name=$2
fi
mkdir -p $HOME/scripts
c_fname=`echo $c_name | tr ' ' '_'`
echo "#!/bin/bash
HOME/git/linux-setup/appconfig/i3/doti3/detacher.sh \"$c_command\"" > $HOME/scripts/$c_fname.sh
chmod +x $HOME/scripts/$c_fname.sh
echo "[Desktop Entry]
Type=Application
Terminal=false
Name=c_name
Exec=$HOME/scripts/$c_fname.sh
Name=$c_name" > $HOME/.local/share/applications/$c_fname.desktop 
