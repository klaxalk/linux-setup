# create alisases
alias gs="git status"
alias gppl="gitPullPush local"
alias gppo="gitPullPush origin"
alias :q=exit
alias octave="octave --no-gui $@"
alias glog="git log --graph --abbrev-commit --date=relative --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
alias cb="catkin build"
alias indie="export PYTHONHTTPSVERIFY=0; python $GIT_PATH/linux-setup/scripts/indie.py"

# reload configuration for urxvt
xrdb ~/.Xresources

# set keyboard repeat rate
xset r rate 350 55

export TERM=rxvt-unicode-256color
# export TERM=screen-256color

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

forceKillTmuxSession() {

  num=`$TMUX_BIN ls 2> /dev/null | grep "$1" | wc -l`
  if [ "$num" -gt "0" ]; then

    pids=`tmux list-panes -s -t "$1" -F "#{pane_pid} #{pane_current_command}" | grep -v tmux | awk '{print $1}'`

    for pid in "$pids"; do
      killp "$pid"
    done

    $TMUX_BIN kill-session -t "$1"

  fi
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

        if [[ "$?" == "0" ]]; then
          case $* in pull*|checkout*) # TODO: should only work for checkout of a branch
            echo "Syncing git submodules"
            command git submodule sync
            echo "Updating git submodules"
            command git submodule update --init --recursive

            HAS_GITMAN=$( gitman show -q 2>&1 )
            if [ -z "$HAS_GITMAN" ]; then
              echo "Updating gitman sub-repos"
              gitman install
            fi
          esac
        fi

        if [[ "$?" == "0" ]]; then
          bash -c "$PROFILE_MANAGER deploy $GIT_PATH/linux-setup/appconfig/profile_manager/file_list.txt"
        fi

      else

        command git "$@"

        if [[ "$?" == "0" ]]; then
          case $* in pull*|checkout*) # TODO: should only work for checkout of a branch
            echo "Syncing git submodules"
            command git submodule sync
            echo "Updating git submodules"
            command git submodule update --init --recursive

            HAS_GITMAN=$( gitman show -q 2>&1 )
            if [ -z "$HAS_GITMAN" ]; then
              echo "Updating gitman sub-repos"
              gitman install
            fi
          esac
        fi

      fi

    else

      command git "$@"

      if [[ "$?" == "0" ]]; then
        case $* in pull*|checkout*) # TODO: should only work for checkout of a branch
          echo "Syncing git submodules"
          command git submodule sync
          echo "Updating git submodules"
          command git submodule update --init --recursive

          HAS_GITMAN=$( gitman show -q 2>&1 )
          if [ -z "$HAS_GITMAN" ]; then
            echo "Updating gitman sub-repos"
            gitman install
          fi
        esac
      fi
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

createSymlinkDatabase() {

  echo "Generating symlink database"

  file_path="/tmp/symlink_list.txt"

  rm "$file_path" > /dev/null 2>&1

  files=`ag -f ~/ --nocolor -g ""`
  dirs=$(echo "$files" | sed -e 's:/[^/]*$::' | uniq)

  for dir in `echo $dirs`
  do
    original=$(readlink "$dir")
    if [[ ! -z "$original" ]];
    then

      if [[ "$original" == "."* ]]
      then
        temp="${dir%/*}/$original"
        original=`( builtin cd "$temp" && pwd )`
      fi

      # echo "$dir -> $original"
      echo "$dir, $original" >> "$file_path"
    fi
  done

  # delete duplicite lines in the file
  mv "$file_path" "$file_path".old
  cat "$file_path".old | uniq > "$file_path"
  rm "$file_path".old
}

symbolicCd() {

  # if ag is missing, run normal "cd"
  if [ ! -x "$(command -v ag)" ]; then

    builtin cd "$@"

    # if we have ag, do the magic
  else

    file_path="/tmp/symlink_list.txt"

    if [ ! -e "$file_path" ]; then
      builtin cd "$@"
      return
    fi

    # parse the csv file and extract file paths
    i="1"
    while IFS=, read -r path1 path2; do

      paths1[$i]=`eval echo "$path1"`
      paths2[$i]=`eval echo "$path2"`

      # echo "${paths1[$i]} -> ${paths1[$i]}"

      i=$(expr $i + 1)
    done < "$file_path"

    builtin cd "$@"
    new_path=`pwd`

    # test original paths for prefix
    # echo ""
    j="1"
    for ((i=1; i < ${#paths1[*]}+1; i++));
    do
      if [[ "$new_path" == *${paths2[$i]}* ]]
      then
        # echo "found prefix: ${paths1[$i]} -> ${paths2[$i]} for $new_path"
        # echo substracted: ${new_path#*${paths2[$i]}}
        repath[$j]="${paths1[$i]}${new_path#*${paths2[$i]}}"
        # echo new_path: ${repath[$j]}
        j=$(expr $j + 1)
        # echo ""
      fi
    done

    if [ "$j" -ge "2" ]
    then
      if [ -e "${repath[1]}" ]
      then

        if [ "$j" -eq "2" ]
        then
          builtin cd "${repath[1]}"
          # elif [ "$j" -gt "2" ]
          # then
          #   builtin cd "${repath[1]}"
          #   echo "FYI There is more than 1 symlink to this directory:"
          #   for ((i=1; i < ${#repath[*]}+1; i++));
          #   do
          #     echo "	${repath[$i]} -> $new_path"
          #   done
        fi
      fi
    fi
  fi
}
alias cd="symbolicCd"

runRanger () {
  command ranger --choosedir="/tmp/lastrangerdir"
  LASTDIR=`cat "/tmp/lastrangerdir"`
  symbolicCd "$LASTDIR"
}
alias ranger=runRanger
alias ra=runRanger

waitForRos() {
  until rostopic list > /dev/null 2>&1; do
    echo "waiting for ros"
    sleep 1;
  done
}

waitForSimulation() {
  until timeout 3s rostopic echo /gazebo/model_states -n 1 --noarr > /dev/null 2>&1; do
    echo "waiting for simulation"
    sleep 1;
  done
  sleep 1;
}

waitForOdometry() {
  until timeout 3s rostopic echo /$UAV_NAME/mavros/local_position/odom -n 1 --noarr > /dev/null 2>&1; do
    echo "waiting for odometry"
    sleep 1;
  done
}

waitForControl() {
  until timeout 3s rostopic echo /$UAV_NAME/control_manager/tracker_status -n 1 --noarr > /dev/null 2>&1; do
    echo "waiting for control"
    sleep 1;
  done
  until timeout 3s rostopic echo /$UAV_NAME/odometry/odom_main -n 1 --noarr > /dev/null 2>&1; do
    echo "waiting for odom_main"
    sleep 1;
  done
}

waitForMpc() {
  until timeout 3s rostopic echo /$UAV_NAME/control_manager/tracker_status -n 1 --noarr > /dev/null 2>&1; do
    echo "waiting for control"
    sleep 1;
  done
  until timeout 3s rostopic echo /$UAV_NAME/odometry/odom_main -n 1 --noarr > /dev/null 2>&1; do
    echo "waiting for odom_main"
    sleep 1;
  done
}

catkin() {

  case $* in

    init*)

      # give me the path to root of the repo we are in
      ROOT_DIR=`git rev-parse --show-toplevel` 2> /dev/null

      command catkin "$@"
      command catkin config --profile debug --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_CXX_FLAGS='-std=c++17 -march=native -fno-diagnostics-color'  -DCMAKE_C_FLAGS='-march=native -fno-diagnostics-color'
      command catkin config --profile release --cmake-args -DCMAKE_BUILD_TYPE=Release -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_CXX_FLAGS='-std=c++17 -march=native -fno-diagnostics-color'  -DCMAKE_C_FLAGS='-march=native -fno-diagnostics-color'
      command catkin config --profile reldeb --cmake-args -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_CXX_FLAGS='-std=c++17 -march=native -fno-diagnostics-color' -DCMAKE_C_FLAGS='-march=native -fno-diagnostics-color'

      command catkin profile set reldeb
      ;;

    build*|b|bt)

      PACKAGES=$(catkin list)
      if [ -z $PACKAGES ]; then
        echo "Cannot compile, not in a workspace"
      else
        command catkin "$@"
      fi

      ;;

    *)
      command catkin "$@"
      ;;

    esac
  }

slack() {

  SLACK_BIN=`which slack-term`

  if [ -z $1 ]
  then
    SLACK_NAME=$(echo "mrs
    eagle" | rofi -i -dmenu -no-custom -p "Select slack")
  else
    SLACK_NAME=${1}
  fi

  mkdir -p ~/git/notes/slack

  case ${SLACK_NAME} in
    mrs)
      SLACK_CFG=~/git/notes/slack/mrsworkspace
      ;;
    eagle)
      SLACK_CFG=~/git/notes/slack/drone-eagleone
      ;;
  esac

  $SLACK_BIN -config $SLACK_CFG
}

git_submodule_recursive() {

  command git submodule foreach git "$@"
}
alias gr="git_submodule_recursive"

repo_to_local() {

  MY_PATH=`dirname "$0"`
  MY_PATH=`( cd "$MY_PATH" && pwd )`

  USER_NAME="klaxalk"
  ADDRESS="localhost"
  SUBFOLDER="test"

  # parse the .gitmodules files in the PATH
  if [ -f "$MY_PATH/$1/.gitmodules" ]; then

    # find each module in the .gitmodules file and extract its relative path from the doublequotes
    SUBMODULES=($( cat "$MY_PATH/$1/.gitmodules" | grep "^\[submodule" | cut -d "\"" -f2 | cut -d "\"" -f1 ))

    cp $MY_PATH/$1/.gitmodules $MY_PATH/$1/.gitmodules_new

    # for each submodule
    for submodule in $SUBMODULES; do

      # recursively find its submodules
      if [ -z "$1" ]; then # if we are in the root repo
        repo_to_local "$submodule"
      else
        repo_to_local "$1/$submodule"
      fi

      # extract the name in the superrepo
      echo SUBMODULE: $submodule
      REPO_NAME=$( echo $submodule | sed -r 's/.*\/([^\/]+)/\1/g' )
      echo REPO_NAME: $REPO_NAME

      # extract the submodule server path
      CMD="cat '$MY_PATH/$1/.gitmodules' | sed -n '/url.*$REPO_NAME\(\.git\)*$/p' | sed -r 's/.*:(.*)$REPO_NAME(\.git)*$/\1/g' | tr -s /"
      SUB_PATH=$( eval $CMD )
      echo SUB_PATH: $SUB_PATH

      # check if the repo was actually created
      CMD="ssh $USER_NAME@$ADDRESS 'test -d ~/$SUBFOLDER/$SUB_PATH/$REPO_NAME'"
      eval $CMD
      RET=$?
      if [[ "$RET" == "0" ]]; then
        echo "Cannot create the repo, already exists...\n"
        continue
      fi

      # create the bare repo
      CMD="ssh $USER_NAME@$ADDRESS 'mkdir -p ~/$SUBFOLDER/$SUB_PATH/$REPO_NAME; cd ~/$SUBFOLDER/$SUB_PATH/$REPO_NAME; git init --bare'"
      eval $CMD

      # check if the repo was actually created
      CMD="ssh $USER_NAME@$ADDRESS 'test -d ~/$SUBFOLDER/$SUB_PATH/$REPO_NAME'"
      eval $CMD
      RET=$?
      if [[ "$RET" != "0" ]]; then
        echo "Cannot create the repo, quitting...\n"
        continue
      fi

      # push the local repo
      cd "$MY_PATH/$1/$submodule"
      git remote remove local
      git remote add local "$USER_NAME@$ADDRESS:~/$SUBFOLDER/$SUB_PATH$REPO_NAME"

      cd "$MY_PATH/$1/$submodule"
      ORIGINAL_REMOTE=`git remote get-url origin`
      echo "$ORIGINAL_REMOTE" > origin_remote.txt
      git add origin_remote.txt
      git commit -m "added origin_remote.txt"

      git push --all local -u
      cd "$MY_PATH"
      git config --file=.gitmodules_new "submodule.$submodule.url" "$USER_NAME@$ADDRESS:~/$SUBFOLDER/$SUB_PATH/$REPO_NAME"
      git submodule sync > /dev/null

      git add "$MY_PATH/$1/$submodule"
      git commit -m "updated the $submodule submodule"

    done

    cp "$MY_PATH/$1/.gitmodules_new" "$MY_PATH/$1/.gitmodules"
    rm "$MY_PATH/$1/.gitmodules_new"

  fi

  # fix the super repo
  if [ -z "$1" ]; then

    # extract the name in the superrepo
    CMD="git remote -v | grep origin | head -n 1 | cut -d ":" -f2 | sed -r 's/.*\/(.+)\s.*$/\1/g'"
    REPO_NAME=$( eval $CMD )
    echo REPO_NAME: $REPO_NAME

    # extract the submodule server path
    CMD="git remote -v | grep origin | head -n 1 | cut -d ":" -f2 | sed -r 's/(.*)$REPO_NAME.*$/\1/g' | tr -s /"
    SUB_PATH=$( eval $CMD )
    echo SUB_PATH: $SUB_PATH

    # check if the repo was actually created
    CMD="ssh $USER_NAME@$ADDRESS 'test -d ~/$SUBFOLDER/$SUB_PATH/$REPO_NAME'"
    eval $CMD
    RET=$?
    if [[ "$RET" == "0" ]]; then
      echo "Cannot create the repo, already exists..."
      return
    fi

    # create the bare repo
    CMD="ssh $USER_NAME@$ADDRESS 'mkdir -p ~/$SUBFOLDER/$SUB_PATH/$REPO_NAME; cd ~/$SUBFOLDER/$SUB_PATH/$REPO_NAME; git init --bare'"
    eval "$CMD"

    # check if the repo was actually created
    CMD="ssh $USER_NAME@$ADDRESS 'test -d ~/$SUBFOLDER/$SUB_PATH/$REPO_NAME'"
    eval $CMD
    RET=$?

    if [[ "$RET" != "0" ]]; then
      echo "Cannot create the repo, quitting..."
      return
    fi

    # push the local repo
    git remote remove local
    git remote add local "$USER_NAME@$ADDRESS:~/$SUBFOLDER/$SUB_PATH/$REPO_NAME"
    git push --all local -u
    git add .gitmodules
    git commit -m "switched .gitmodules to local"
    git push

  fi
}

repo_reset_origin() {

  MY_PATH=`dirname "$0"`
  MY_PATH=`( cd "$MY_PATH" && pwd )`

  USER_NAME="git"
  ADDRESS="mrs.felk.cvut.cz"
  SUBFOLDER=""

  # parse the .gitmodules files in the PATH
  if [ -f "$MY_PATH/$1/.gitmodules" ]; then

    # find each module in the .gitmodules file and extract its relative path from the doublequotes
    SUBMODULES=($( cat "$MY_PATH/$1/.gitmodules" | grep "^\[submodule" | cut -d "\"" -f2 | cut -d "\"" -f1 ))

    cp $MY_PATH/$1/.gitmodules $MY_PATH/$1/.gitmodules_new

    # for each submodule
    for submodule in $SUBMODULES; do

      # recursively find its submodules
      if [ -z "$1" ]; then # if we are in the root repo
        repo_reset_origin "$submodule"
      else
        repo_reset_origin "$1/$submodule"
      fi

      # extract the name in the superrepo
      echo SUBMODULE: $submodule
      REPO_NAME=$( echo $submodule | sed -r 's/.*\/([^\/]+)/\1/g' )
      echo REPO_NAME: $REPO_NAME

      # extract the submodule server path
      CMD="cat '$MY_PATH/$1/.gitmodules' | sed -n '/url.*$REPO_NAME\(\.git\)*$/p' | sed -r 's/.*:(.*)$REPO_NAME(\.git)*$/\1/g' | tr -s /"
      SUB_PATH=$( eval $CMD )
      echo SUB_PATH: $SUB_PATH

      # change the remote to the new address
      cd "$MY_PATH"
      NEW_PATH=`cat origin_remote.txt`
      git config --file=.gitmodules_new "submodule.$submodule.url" $NEW_PATH
      git submodule sync > /dev/null

    done

    cp "$MY_PATH/$1/.gitmodules_new" "$MY_PATH/$1/.gitmodules"
    rm "$MY_PATH/$1/.gitmodules_new"

  fi

  # fix the super repo
  if [ -z "$1" ]; then

    # extract the name in the superrepo
    CMD="git remote -v | grep origin | head -n 1 | cut -d ":" -f2 | sed -r 's/.*\/(.+)\s.*$/\1/g'"
    REPO_NAME=$( eval $CMD )
    echo REPO_NAME: $REPO_NAME

    # extract the submodule server path
    CMD="git remote -v | grep origin | head -n 1 | cut -d ":" -f2 | sed -r 's/(.*)$REPO_NAME.*$/\1/g' | tr -s /"
    SUB_PATH=$( eval $CMD )
    echo SUB_PATH: $SUB_PATH

    # push the origin repo
    git remote remove origin
    git remote add origin "$USER_NAME@$ADDRESS:~/$SUBFOLDER/$SUB_PATH/$REPO_NAME"
    git add .gitmodules
    git commit -m "switched .gitmodules to origin"

  fi
}

CURRENT_PATH=`pwd`
cd "$CURRENT_PATH"
