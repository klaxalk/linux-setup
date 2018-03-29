#!/bin/bash

STATUS_FILE=".git_status"
text_line=""

# TODO: use environment variable $GIT_PATH
cd ~/git

# check if STATUS_FILE exists 
if [ -f "${STATUS_FILE}" ]; then
  
  # read each line in the file
  while read line; do
    
    #split the line using delimiter ':' 
    repo_name="$(cut -d':' -f1 <<<"$line")"
    repo_status="$(cut -d':' -f2 <<<"$line")"

    # if repo_status start with text "Your branch is behind"
    if [ "${repo_status:1:21}" == "Your branch is behind" ]; then
      
      # if text_line is empty
      if [ -z "${text_line// }"];then
        text_line="$repo_name" 
      else
        text_line="$text_line, $repo_name" 
      fi
    fi
  done < ${STATUS_FILE}
fi

echo "$text_line"
