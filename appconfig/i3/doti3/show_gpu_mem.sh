#!/bin/bash
# author: Ondrej Prochazka

OUTPUT=$(echo ''; nvidia-smi --query-gpu=memory.free --format=csv,noheader; echo '') 
echo $OUTPUT

