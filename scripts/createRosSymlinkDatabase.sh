#!/bin/bash

echo "Generating symlink database"

file_path="/tmp/symlink_list.txt"

rm "$file_path" > /dev/null 2>&1

IFS=' ' read -r -a WORKSPACES <<< "$ROS_WORKSPACE" # `

dirs=""

# for both
for ((j=0; j < ${#WORKSPACES[*]}; j++));
do

  # get me the absolute path
  eval workspace_path=${WORKSPACES[$j]}

  echo "running silver searcher on '$workspace_path'"

  workspace_files=`ag -f $workspace_path --nocolor -g ""`
  workspace_dirs=$(echo "$workspace_files" | sed -e 's:/[^/]*$::' | sort | uniq)

  dirs="$dirs $workspace_dirs"

done

# for all the symlinks that we found
for dir in `echo $dirs`
do

  # echo "Evaluating: $dir"

  # "original" = where the link is pointing to
  original=$(readlink "$dir")

  # if the "original" path is not empty
  if [[ ! -z "$original" ]];
  then

    # if the "original" path starts with "."
    # which means its a relative link
    if [[ "$original" == "."* ]]
    then

      # resolve the relative link
      temp="${dir%/*}/$original"
      original=`( builtin cd "$temp" && pwd )`
    fi

    # the linked path must not contains /git/
    if [[ $dir == *\/git\/* ]]
    then
      echo -e "\e[31mReject $dir\e[39m"
      continue
    else
      echo -e "\e[32mAccept: $dir -> $original\e[39m"
    fi

    # put it into our output file
    echo "$dir, $original" >> "$file_path"
  fi
done

# delete duplicite lines in the file
mv "$file_path" "$file_path".old
cat "$file_path".old | uniq > "$file_path"
rm "$file_path".old
