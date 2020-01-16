#!/usr/bin/env bash
# Depends on: xdotool
# Taken from: https://faq.i3wm.org/question/4074/changing-window-title.1.html

xdotool set_window --name "$*" `xdotool getactivewindow`
