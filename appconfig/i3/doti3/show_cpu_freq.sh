#!/bin/bash

OUTPUT=$(lscpu | grep "CPU MHz" | rev | cut -d' ' -f1 | cut -d'.' -f2 | rev; echo 'MHz') 
echo $OUTPUT
