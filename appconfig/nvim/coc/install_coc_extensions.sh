#!/bin/bash

# get the path to this script
APP_PATH=`dirname "$0"`
APP_PATH=`( cd "$APP_PATH" && pwd )`

# List of extensions
extensions=(
  "coc-python"
  "coc-tsserver"
  "coc-json"
  "coc-clangd"
  "coc-sh"
  "coc-snippets"
)

# Install extensions
for ext in "${extensions[@]}"
do
  /usr/bin/nvim --cmd 'let g:user_mode=1' --headless -c "CocInstall $ext" -c "qa"
done

[ -e ~/.config/coc/ultisnips ] && rm -rf ~/.config/coc/ultisnips
ln -sf $APP_PATH/ultisnips ~/.config/coc

echo "All extensions installed!"
