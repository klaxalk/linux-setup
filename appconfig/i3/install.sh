#!/bin/bash

set -e

trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "$0: \"${last_command}\" command failed with exit code $?"' ERR

# get the path to this script
APP_PATH=`dirname "$0"`
APP_PATH=`( cd "$APP_PATH" && pwd )`

unattended=0
for param in "$@"
do
  echo $param
  if [ $param="--unattended" ]; then
    echo "installing in unattended mode"
    unattended=1
    subinstall_params="--unattended"
  fi
done

var1="18.04"
var2=`lsb_release -r | awk '{ print $2 }'`
[ "$var2" = "$var1" ] && export BEAVER=1

default=y
while true; do
  if [[ "$unattended" == "1" ]]
  then
    resp=$default
  else
    [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall i3? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    sudo apt-get -y install libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf libxcb-xrm0 libxcb-xrm-dev automake libxcb-shape0-dev dunst libkeybinder-3.0-0

    if [ -n "$BEAVER" ]; then
      sudo apt-get -y install python-keybinder gir1.2-keybinder
    fi

    # required for i3-layout-manager
    sudo apt-get -y install jq rofi xdotool x11-xserver-utils indent libanyevent-i3-perl

    if [ "$unattended" == "0" ] && [ -z $TRAVIS ]; # if running interactively
    then
      # install graphical X11 graphical backend with lightdm loading screen
      echo ""
      echo "-----------------------------------------------------------------"
      echo "Installing lightdm login manager. It might require manual action."
      echo "-----------------------------------------------------------------"
      echo "If so, please select \"lightdm\", after hitting Enter"
      echo ""
      echo "Waiting for Enter..."
      echo ""
      read
    fi

    sudo apt-get -y install lightdm

    # compile i3 dependency which is not present in the repo
    sudo apt-get -y install xutils-dev

    cd /tmp
    [ -e xcb-util-xrm ] && rm -rf /tmp/xcb-util-xrm
    git clone https://github.com/Airblader/xcb-util-xrm
    cd xcb-util-xrm
    git submodule update --init
    ./autogen.sh --prefix=/usr
    make
    sudo make install

    # install light for display backlight control
    # compile i3
    sudo apt-get -y install help2man

    cd $APP_PATH/../../submodules/light/
    ./autogen.sh
    ./configure && make
    sudo make install
    # set the minimal backlight value to 5%
    light -N 5
    # clean up after the compilation
    make clean
    git clean -fd

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

    # clean after myself
    git reset --hard
    git clean -fd

    # compile i3 blocks
    cd $APP_PATH/../../submodules/i3blocks/
    ./autogen.sh
    ./configure
    make
    sudo make install

    # clean after myself
    git reset --hard
    git clean -fd

    # for cpu usage in i3blocks
    sudo apt-get -y install sysstat

    # for brightness and volume control
    sudo apt-get -y install xbacklight alsa-utils pulseaudio feh arandr

    arch=$( uname -i )
    if [ "$arch" != "aarch64" ]; then
      sudo apt-get -y install acpi
    fi

    # for making gtk look better
    sudo apt-get -y install lxappearance

    # indicator-sound-switcher
    sudo apt-get -y install libappindicator3-dev gir1.2-keybinder-3.0
    cd $APP_PATH/../../submodules/indicator-sound-switcher
    sudo python3 setup.py install

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
    mkdir -p ~/.fonts
    cp $APP_PATH/fonts/* ~/.fonts/

    # link fonts.conf file
    mkdir -p ~/.config/fontconfig
    ln -sf $APP_PATH/fonts.conf ~/.config/fontconfig/fonts.conf

    # install useful gui utils
    sudo apt-get -y install thunar rofi compton systemd

    $APP_PATH/make_launchers.sh $APP_PATH/../../scripts

    # disable nautilus
    gsettings set org.gnome.desktop.background show-desktop-icons false

    # install xkb layout state
    cd $APP_PATH/../../submodules/xkblayout-state/
    make
    sudo ln -sf $APP_PATH/../../submodules/xkblayout-state/xkblayout-state /usr/bin/xkblayout-state

    sudo apt-get -y install i3lock

    # install prime-select (for switching gpus)
    # sudo apt-get -y install nvidia-prime

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi

done
