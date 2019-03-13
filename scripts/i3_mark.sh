#!/bin/bash

MARK_LIST="1\n2\n3\n4\nunmark"

selected=`echo -e $MARK_LIST | \
	rofi \
	-dmenu \
	-markup_rows \
	-hide-scrollbar \
	-bw 2 \
	-m -2 \
	-eh 1 \
	-i \
  -location 3 \
	-width -10 \
	-p Mark \
	-padding 0 \
	-line-margin 0 \
	-line-padding 0`

if [[ $1 != jump ]]; then
	if [ ${#selected} -gt 0 ]
	then
	    case $selected in
        unmark)
          i3-msg "unmark"
          ;;
      	1)
          i3-msg "mark --add --toggle 1"
          ;;
        2)
          i3-msg "mark --add --toggle 2" 
          ;;
        3)
          i3-msg "mark --add --toggle 3" 
          ;;
        4)
          i3-msg "mark --add --toggle 4" 
          ;;
      	*)
      	  i3-msg "mark --add --toggle $selected" 
      	  ;;
        esac
    fi
else
        if [ ${#selected} -gt 0 ]
    then
        case $selected in
        unmark)
          i3-msg [class=".*"] unmark
          ;;
        1)
          i3-msg [con_mark="1"] focus
          ;;
        2)
          i3-msg "[ con_mark ="2"] focus"
          ;;
        3)
          i3-msg "[ con_mark ="3"] focus"
          ;;
        4)
          i3-msg "[ con_mark ="4"] focus"
          ;;
        *)
          i3-msg "[con_mark = $selected ] focus"
          ;;
        esac
    fi
fi
