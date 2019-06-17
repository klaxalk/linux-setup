#/usr/bin/env bas

action="toggle"
if [ $# -ge 1 ]; then
  action=$1
fi

playerctl -v > /dev/null 2>&1
pctl_res=$?
if [ $pctl_res -eq 0 ]; then
  cmd_toggle="playerctl play-pause";
  cmd_play="playerctl play";
  cmd_pause="playerctl pause";
  cmd_previous="playerctl previous";
  cmd_next="playerctl next";
else
  cmd_toggle="dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause";
  cmd_play="dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Play";
  cmd_pause="dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Pause";
  cmd_previous="dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous";
  cmd_next="dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next";
fi

case $action in
     "toggle")      
          ### Firefox toggle playback using the Play/Pause addon (https://addons.mozilla.org/en-US/firefox/addon/play-pause/)
          # xdotool search --name "Mozilla Firefox" key Alt_L+Shift_L+p
          ### Spotify toggle playback
          ($cmd_toggle) > /dev/null
          ;;
     "play")      
          ### Spotify play
          ($cmd_play) > /dev/null
          ;;
     "pause")
          ### Spotify pause
          ($cmd_pause) > /dev/null
          ;; 
     "previous")
          ### Spotify prev song
          ($cmd_previous) > /dev/null
          ;;
     "next")
          ### Spotify next song
          ($cmd_next) > /dev/null
          ;;
     *)
          echo "Invalid option! Allowed options are: toggle|play|pause|previous|next or none (equals to toggle)." > /dev/stderr
          ;;
esac

