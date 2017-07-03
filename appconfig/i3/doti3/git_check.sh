#!/bin/bash

REMOTE="origin"
STATUS_FILE=".git_status"
REPOSITORY="git"


cd ~/${REPOSITORY}

if [ -f "/tmp/${STATUS_FILE}" ]; then
  rm "/tmp/$STATUS_FILE"
fi
touch "/tmp/$STATUS_FILE"

# check internet connection
if ping -c 1 google.com >> /dev/null 
then
  # for each repository
  for D in *; do
    # if is folder
    if [ -d "${D}" ]; then
      cd ~/${REPOSITORY}/${D}
      if [ -d ".git" ]; then
        # git fetch
        git fetch ${REMOTE} &> /dev/null
        state=`git status | head -2 | tail -1`
        echo -e "${D}"": ""$state" >> "/tmp/$STATUS_FILE"
      fi
      cd ~/${REPOSITORY}
    fi
  done
fi

cp "/tmp/$STATUS_FILE" .
