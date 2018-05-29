#!/bin/bash

STATUS_FILE=".git_status"

# TODO: use environment variable $GIT_PATH
cd ~/git

# check if STATUS_FILE exists 
if [ -f "${STATUS_FILE}" ]; then
  
  # read each line in the file
  while read line; do
    # contains just one line, or it is empty
    echo "$text_line"
  done < ${STATUS_FILE}
fi

