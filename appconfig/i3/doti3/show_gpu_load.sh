#!/bin/bash
# author: Ondrej Prochazka

# OUTPUT=$(echo '_'; nvidia-smi --query-gpu=memory.free --format=csv,noheader; echo '') 
OUTPUT=$(echo '';nvidia-smi -q | grep Gpu | cut -c 44-) 
echo $OUTPUT

