#!/bin/bash
ACTION=$( echo "lock
shutdown
reboot
logout
suspend
hibernate" | rofi -dmenu -p "Select desired action:")

case "$ACTION" in
    lock)
        i3lock-fancy --pixelate
        ;;
    logout)
        i3-msg exit
        ;;
    suspend)
        i3lock && systemctl suspend
        ;;
    hibernate)
        i3lock && systemctl hibernate
        ;;
    reboot)
        systemctl reboot
        ;;
    shutdown)
        systemctl poweroff
        ;;
    *)
esac
