#!/bin/bash

STATUS_FILE=".git_status"
REPOSITORY="git"

text_line=""

cd ~/${REPOSITORY}
if [ -f "${STATUS_FILE}" ]; then
  while read line; do
    A="$(cut -d':' -f1 <<<"$line")"
    B="$(cut -d':' -f2 <<<"$line")"
    if [ "${B:1:21}" == "Your branch is behind" ]; then
      if [ -z "${text_line// }"];then
        text_line="$A" 
      else
        text_line="$text_line, $A" 
      fi
    fi
  done < ${STATUS_FILE}
fi

echo "$text_line"
