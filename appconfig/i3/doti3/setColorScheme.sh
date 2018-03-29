setColorScheme() {

  export COLOR_SCHEME="$1"

  # change the variable in bashrc
  /usr/bin/vim -u ~/git/linux-setup/submodules/dotprofiler/epigen/epigen.vimrc -E -s -c "%g/.*PROFILER.*COLORSCHEME.*/norm ^/COLORSCHEMEciwCOLORSCHEME_$COLOR_SCHEME" -c "wqa" -- ~/.zshrc

  source ~/.zshrc

  OLD_PATH=`pwd`

  cd "$GIT_PATH/linux-setup"
  ./backup_and_deploy.sh

  # reload configuration for urxvt
  xrdb ~/.Xresources

  # restart i3
  i3-msg restart

  cd "$OLD_PATH"
}
