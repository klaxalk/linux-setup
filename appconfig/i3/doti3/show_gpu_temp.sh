#!/bin/bash
# author: Ondrej Prochazka

OUTPUT=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader 2>&1)

if echo "$OUTPUT" | grep -q "NVIDIA-SMI has failed"; then
    echo "off"
else
    echo "${OUTPUT}°C"
fi
