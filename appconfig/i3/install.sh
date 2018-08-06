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
    sudo apt -y install i3
    if [ "$?" != "0" ]; then echo "Press Enter to continues.."; read; fi

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

    sudo apt -y install libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf
    if [ "$?" != "0" ]; then echo "Press Enter to continues.."; read; fi

    # install graphical X11 graphical backend with lightdm loading screen
    sudo apt -y install lightdm xserver-xorg
    if [ "$?" != "0" ]; then echo "Press Enter to continues.."; read; fi

    # compile i3 dependency which is not present in the repo
    sudo apt -y install xutils-dev
    if [ "$?" != "0" ]; then echo "Press Enter to continues.."; read; fi

    cd /tmp
    git clone https://github.com/Airblader/xcb-util-xrm
    cd xcb-util-xrm
    git submodule update --init
    ./autogen.sh --prefix=/usr
    make
    sudo make install

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
    sudo apt -y install xbacklight alsa-utils pulseaudio feh arandr acpi
    if [ "$?" != "0" ]; then echo "Press Enter to continues.."; read; fi

    # for making gtk look better
    sudo apt -y install lxappearance 
    if [ "$?" != "0" ]; then echo "Press Enter to continues.."; read; fi

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
    sudo apt -y install indicator-sound-switcher
    if [ "$?" != "0" ]; then echo "Press Enter to continues.."; read; fi

    # symlink settings folder
    if [ ! -e ~/.i3 ]; then
      ln -sf $APP_PATH/doti3 ~/.i3
    fi

    # copy i3 config file
    cp $APP_PATH/doti3/config_git ~/.i3/config
    cp $APP_PATH/doti3/i3blocks.conf_git ~/.i3/i3blocks.conf
    cp $APP_PATH/i3blocks/wifi_git $APP_PATH/i3blocks/wifi
    cp $APP_PATH/i3blocks/battery_git $APP_PATH/i3blocks/battery

    # copy fonts
    # fontawesome 4.7 
    mkdir ~/.fonts
    cp $APP_PATH/fonts/* ~/.fonts/

    # link fonts.conf file
    mkdir ~/.config/fontconfig
    ln -sf $APP_PATH/fonts.conf ~/.config/fontconfig/fonts.conf         

    # install thunar
    sudo apt -y install thunar rofi compton i3blocks systemd
    if [ "$?" != "0" ]; then echo "Press Enter to continues.."; read; fi

    # put $USE_I3 into bashrc
    num=`cat ~/.bashrc | grep "USE_I3" | wc -l`
    if [ "$num" -lt "1" ]; then

      echo "
# do you use i3?
export USE_I3=false" >> ~/.bashrc

    fi

    # disable nautilus
    gsettings set org.gnome.desktop.background show-desktop-icons false

    # install xkblayout state
    bash $APP_PATH/../xkblayout-state/install.sh

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi

done
