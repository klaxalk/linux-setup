#!/bin/bash
# author: Viktor Walter
# is supposed to switch between two keyboard layouts

# CURRENT_LAYOUT=$(setxkbmap -query | awk '/layout/{print $2}') 

# echo $CURRENT_LAYOUT | sed 's/.*/\U&/'

CURRENT_LAYOUT=$(xkblayout-state print "%s") 

echo $CURRENT_LAYOUT
