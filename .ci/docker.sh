#!/bin/bash

set -e

trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "$0: \"${last_command}\" command failed with exit code $?"' ERR

docker build . --file Dockerfile --tag klaxalk/linux-setup:master

docker login --username klaxalk --password $TOKEN

docker push klaxalk/linux-setup:master
