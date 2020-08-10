#!/bin/bash


if [[ ! -z $(mpc status | grep playing) ]]; then
  echo '▶️'
else 
  echo '||'
fi
