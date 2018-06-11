# create alisases
alias gs="git status"
alias gppl="gitPullPush local"
alias gppo="gitPullPush origin"
alias :q=exit
alias octave="octave --no-gui $@"
alias glog="git log --graph --abbrev-commit --date=relative --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"

runRanger () {
  ranger --choosedir="$HOME/rangerdir";
  LASTDIR=`cat "$HOME/rangerdir"`;
  cd "$LASTDIR"
}
alias ranger=runRanger
alias ra=runRanger

# use ctags to generate code tags
generateTags() {

  # generate project's tags
  # TODO check for file existence
  ctagscmd="ctags --fields=+l -f ~/tags $CTAGS_SOURCE_DIR"
  eval $ctagscmd

  # generate `once generated tags`, e.g. ROS's tags
  if [ ! -e $(eval echo "$CTAGS_FILE_ONCE") ]; then
    echo "generating one-time generated tags"
    ctagscmd="ctags --fields=+l -f $CTAGS_FILE_ONCE $CTAGS_ONCE_SOURCE_DIR"
    eval $ctagscmd
  fi 
}

# allows killing process with all its children
killp() {

  if [ $# -eq 0 ]; then
    pes=$( cat ) 
  else
    pes=$1
  fi

  for child in $(ps -o pid,ppid -ax | \
    awk "{ if ( \$2 == $pes ) { print \$1 }}")
do
  # echo "Killing child process $child because ppid = $pes"
  killp $child
done

# echo "killing $1"
kill -9 "$1" > /dev/null 2> /dev/null
}

killSession() {

  if [ ! -z "$TMUX" ]; then

    echo "killing session"
    pids=`tmux list-panes -s -F "#{pane_pid} #{pane_current_command}" | grep -v tmux | awk {'print $1'}`

    for pid in $pids; do
      killp "$pid" &
    done

    SESSION_NAME=`tmux display-message -p '#S'`
    tmux kill-session -t "$SESSION_NAME"

  else

    exit

  fi
}
alias :qa="killSession"

gitPullPush() {

  branch=`git branch | grep \* | sed 's/\* \([a-Z]*\)/\1/'`

  if [ $# -eq 0 ]; then
    git pull origin "$branch"
    git push origin "$branch"
  else
    git pull "$1" "$branch"
    git push "$1" "$branch"
  fi
}

getVideoThumbnail () {

  if [ $# -eq 0 ]; then
    echo "did not get input"
    exit 1
  elif [ $# -eq 1 ]; then
    echo "gettin the first frame"
    file="$1"
    frame="00:00:01"
  elif [ $# -eq 2 ]; then
    file="$1"
    frame="$2"
  fi

  output="${file%.*}_thumbnail.jpg"
  ffmpeg -i "$file" -ss "$frame" -vframes 1 "$output"
}

# upgrades the "git pull" to allow dotfiles profiling on linux-setup
# Other "git" features should not be changed
git() {

  case $* in pull*|checkout*|"reset --hard")

    # give me the path to root of the repo we are in
    ROOT_DIR=`git rev-parse --show-toplevel` 2> /dev/null

    if [[ "$?" == "0" ]]; then

      # if we are in the 'linux-setup' repo, use the Profile manager
      if [[ "$ROOT_DIR" == "$GIT_PATH/linux-setup" ]]; then

        PROFILE_MANAGER="$GIT_PATH/linux-setup/submodules/profile_manager/profile_manager.sh"

        bash -c "$PROFILE_MANAGER backup $GIT_PATH/linux-setup/appconfig/profile_manager/file_list.txt"

        command git "$@"

        case $* in pull*)
          echo "Updating git submodules"
          command git submodule update --init --recursive
        esac

        if [[ "$?" == "0" ]]; then

          bash -c "$PROFILE_MANAGER deploy $GIT_PATH/linux-setup/appconfig/profile_manager/file_list.txt"

        fi

      else
        command git "$@"
        case $* in pull*)
          echo "Updating git submodules"
          command git submodule update --init --recursive
        esac
      fi

    else
      command git "$@"
      case $* in pull*)
        echo "Updating git submodules"
        command git submodule update --init --recursive
      esac
    fi

    ;;
  *)
    command git "$@"
    ;;

  esac
}

getRcFile() {

  case "$SHELL" in 
    *bash*)
      RCFILE="$HOME/.bashrc"
      ;;
    *zsh*)
      RCFILE="$HOME/.zshrc"
      ;;
  esac

  echo "$RCFILE"
}

sourceShellDotfile() {

  RCFILE=$( getRcFile )

  source "$RCFILE"
}
alias sb="sourceShellDotfile"

# special code for i3 users
if [ "$USE_I3" = "true" ]; then

  # reload configuration for urxvt
  xrdb ~/.Xresources

  # set keyboard repeat rate
  xset r rate 350 55

  echo '#!/bin/bash
  echo '"$ROS_IP" > ~/.i3/ros_ip.sh
  chmod +x ~/.i3/ros_ip.sh

  echo '#!/bin/bash
  echo '"$ROS_MASTER_URI" | sed 's/http:\/\/\(.*\):.*/\1/' > ~/.i3/ros_master_uri.sh
  chmod +x ~/.i3/ros_master_uri.sh

  echo '#!/bin/bash
  echo '"$UAV_NAME" > ~/.i3/uav_name.sh
  chmod +x ~/.i3/uav_name.sh

  export TERM=rxvt-unicode-256color

fi
