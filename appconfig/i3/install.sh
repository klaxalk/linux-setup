#!/bin/bash

# get the path to this script
APP_PATH=`dirname "$0"`
APP_PATH=`( cd "$APP_PATH" && pwd )`

default=y
while true; do
  [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall i3? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    # install i3
    sudo apt-get -y install i3

    # install dependencies for compilation of i3gaps
    sudo expect -c "
    spawn sudo add-apt-repository ppa:aguignard/ppa
    expect { 
      \"ENTER\" {
        send "\\n"
        interact
      }
    }
    "
    sudo apt-get update
    sudo apt-get -y install libxcb-xrm-dev

    sudo apt-get -y install libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf

    # install graphical X11 graphical backend with lightdm loading screen
    sudo apt-get -y install lightdm xserver-xorg

    # compile i3
    cd $APP_PATH/../../submodules/i3/
    autoreconf --force --install
    rm -rf build/
    mkdir -p build && cd build/

    # Disabling sanitizers is important for release versions!
    # The prefix and sysconfdir are, obviously, dependent on the distribution.
    ../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
    make
    sudo make install

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
    ln -sf $APP_PATH/doti3 ~/.i3

    # copy fonts
    # fontawesome 4.7 
    mkdir ~/.fonts
    cp $APP_PATH/fonts/* ~/.fonts/

    # install thunar
    sudo apt-get -y install thunar rofi compton i3blocks systemd

    # put $USE_I3 into bashrc
    num=`cat ~/.bashrc | grep "USE_I3" | wc -l`
    if [ "$num" -lt "1" ]; then

      echo "
# do you use i3?
export USE_I3=false" >> ~/.bashrc

    fi

    # disable nautilus
    gsettings set org.gnome.desktop.background show-desktop-icons false

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi

done
