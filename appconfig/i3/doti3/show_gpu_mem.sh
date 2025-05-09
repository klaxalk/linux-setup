#!/bin/bash
# author: Ondrej Prochazka

OUTPUT=$(nvidia-smi --query-gpu=memory.free --format=csv,noheader 2>&1)

if echo "$OUTPUT" | grep -q "NVIDIA-SMI has failed"; then
    echo ""
else
    echo "${OUTPUT}"
fi
