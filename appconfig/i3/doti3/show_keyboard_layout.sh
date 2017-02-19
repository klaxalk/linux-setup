#!/bin/bash
# author: Tomas Baca
# is supposed to switch between two keyboard layouts

CURRENT_LAYOUT=$(setxkbmap -query | awk '/layout/{print $2}') 

echo $CURRENT_LAYOUT | sed 's/.*/\U&/'
