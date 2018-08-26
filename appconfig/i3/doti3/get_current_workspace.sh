#!/bin/bash
i3-msg -t get_workspaces \
  | jq '.[] | select(.focused==true).num' \
  | cut -d"\"" -f2
