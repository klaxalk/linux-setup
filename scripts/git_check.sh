#!/bin/bash

REMOTE="origin"
STATUS_FILE=".git_status"

if [ -z $GIT_REMOTES ]; then
  GIT_REMOTES=""
fi

WORK_PATH=${GIT_PATH}
cd "$WORK_PATH"
# echo "path: ${WORK_PATH}"

# if [ -f "/tmp/${STATUS_FILE}" ]; then
#   rm "/tmp/$STATUS_FILE"
# fi
# touch "/tmp/$STATUS_FILE"

text_line=""
repo_counter=0
MAX_REPO_COUNTER=3

# create a list from GIT_REMOTES using delimiter 'white space'
GIT_REMOTES_LIST=${GIT_REMOTES//,/$'\n'}  # change the ',' to white space

# check internet connection
# if ping -c 1 google.com >> /dev/null
# then

# for each folder in GIT_REPOSITORY
for D in *; do

  # if is folder
  if [ -d "${D}" ]; then
    cd ${WORK_PATH}/${D}

    # check if folder is git repository
    if [ -d ".git" ]; then

      # find if for this repository different remote should be check
      var_remote=$REMOTE
      for word in "$GIT_REMOTES_LIST"
      do
        repo_name="$(cut -d':' -f1 <<<"$word")"
        repo_remote="$(cut -d':' -f2 <<<"$word")"
        if [ "$repo_name" == "${D}" ] ; then
          var_remote=$repo_remote
        fi
      done
      # echo "- checking - ${D}: $var_remote"

      # git fetch
      git fetch $var_remote &> /dev/null
      repo_status=`git status | head -2 | tail -1`
      # echo -e "${D}"": ""$state" >> "/tmp/$STATUS_FILE"

      # if repo_status start with text "Your branch is behind"
      if [ "${repo_status:0:21}" == "Your branch is behind" ]; then

        # check how long is the list already
        if [ "$repo_counter" -ge "$MAX_REPO_COUNTER" ]; then
          text_line="$text_line, ..."
          cd ${WORK_PATH}
          break;
        fi
        repo_counter=$((repo_counter + 1))

        # if text_line is empty
        if [ -z "${text_line// }" ];then
          text_line="${D}"
        else
          text_line="${text_line}, ${D}"
        fi
      fi
    fi
    cd ${WORK_PATH}
  fi
done
# fi

echo "$text_line"
