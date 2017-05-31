#!/bin/bash

# get the path to this script
APP_PATH=`dirname "$0"`
APP_PATH=`( cd "$APP_PATH" && pwd )`

while true; do
  [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall i3? [y/n]\e[0m\n' resp || resp="y" ; }
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    toilet installing i3

    # install i3
    sudo apt-get -y install i3

    # for brightness and volume control
    sudo apt-get -y install xbacklight alsa-utils pulseaudio feh arandr acpi

    # for making gtk look better
    sudo apt-get -y install lxappearance 

    sudo expect -c "
    spawn apt-add-repository ppa:yktooo/ppa
    expect { 
      \"adding it\" {
        send "\\n"
        interact
      }
    }
    "
    sudo apt-get update
    sudo apt-get -y install indicator-sound-switcher

    # symlink i3 settings
    rm ~/.i3
    ln -s $APP_PATH/doti3 ~/.i3

    # copy fonts
    # fontawesome 4.7 
    mkdir ~/.fonts
    cp $APP_PATH/fonts/* ~/.fonts/

    # symlink gtk settings
    ln -s $APP_PATH/gtk/dotgtkrc-2.0 ~/.gtkrc-2.0
    rm ~/.config/gtk-3.0/settings.ini
    ln -s $APP_PATH/gtk/settings.ini ~/.config/gtk-3.0/

    # install thunar
    sudo apt-get -y install thunar rofi compton i3blocks systemd

    # put $USE_I3 into bashrc
    num=`cat ~/.bashrc | grep "USE_I3" | wc -l`
    if [ "$num" -lt "1" ]; then

      echo "
# do you use i3?
export USE_I3=false" >> ~/.bashrc

    fi

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi

done
