#!/bin/bash
if synclient -l | grep "TouchpadOff .*=.*0" ; then
  synclient TouchpadOff=1 ;

  # banish mouse
  xdotool mousemove 10000 10000
else
  synclient TouchpadOff=0 ;
fi
