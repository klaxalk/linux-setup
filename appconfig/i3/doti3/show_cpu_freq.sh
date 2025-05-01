#!/bin/bash

OUTPUT=$(cpupower frequency-info | grep "asserted by call to kernel" | awk '{print $4, $5}') 
echo $OUTPUT
