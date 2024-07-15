#!/bin/bash

set -e

trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "$0: \"${last_command}\" command failed with exit code $?"' ERR

docker login --username klaxalk --password $TOKEN

docker buildx create --name container --driver=docker-container
docker buildx build . --file Dockerfile --builder container --tag klaxalk/linux-setup:master --platform=linux/amd64,linux/arm64 --push 
