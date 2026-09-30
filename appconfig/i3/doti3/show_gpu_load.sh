#!/bin/bash
# author: Ondrej Prochazka

# OUTPUT=$(echo '_'; nvidia-smi --query-gpu=memory.free --format=csv,noheader; echo '') 
OUTPUT=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)
echo "${OUTPUT} %"
