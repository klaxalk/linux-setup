#!/bin/bash

source ~/.bashrc

REMOTE="origin"
STATUS_FILE=".git_status"

cd ${GIT_PATH}

if [ -f "/tmp/${STATUS_FILE}" ]; then
  rm "/tmp/$STATUS_FILE"
fi
touch "/tmp/$STATUS_FILE"

# create a list from GIT_REMOTES using delimiter 'white space'
GIT_REMOTES_LIST=${GIT_REMOTES//,/$'\n'}  # change the ',' to white space

# check internet connection
# if ping -c 1 google.com >> /dev/null 
# then

# for each folder in GIT_REPOSITORY
for D in *; do
  
  # if is folder
  if [ -d "${D}" ]; then
    cd ${GIT_PATH}/${D}
    
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
      # echo "$D $var_remote"
      
      # git fetch
      git fetch $var_remote &> /dev/null
      state=`git status | head -2 | tail -1`
      echo -e "${D}"": ""$state" >> "/tmp/$STATUS_FILE"
    
    fi
    cd ${GIT_PATH}
  fi
done
# fi

cp "/tmp/$STATUS_FILE" .
