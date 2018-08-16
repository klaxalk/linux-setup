#!/bin/bash
# author: Vojtech Spurny


CURRENT_GPU=$(prime-select query) 

echo $CURRENT_GPU

if [ "$CURRENT_GPU" = "nvidia" ]; then exit 33; fi
