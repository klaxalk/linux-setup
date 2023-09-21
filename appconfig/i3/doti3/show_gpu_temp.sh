#!/bin/bash
# author: Ondrej Prochazka

OUTPUT=$(echo ''; nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader; echo '°C') 
echo $OUTPUT

