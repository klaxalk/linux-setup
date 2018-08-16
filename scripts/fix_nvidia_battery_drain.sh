#!/bin/bash

# Get the path to this script
APP_PATH=`dirname "$0"`
APP_PATH=`( cd "$APP_PATH" && pwd )`

# Copy the service
sudo cp $APP_PATH/gpuoff.service /lib/systemd/system/gpuoff.service

# Start the service on startup
sudo systemctl enable gpuoff
