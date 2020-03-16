#!/usr/bin/env bash

## Complete the following steps to get Docker running locally
DOCKER_TAG=make-prediction:latest

# Step 1:
# Build image and add a descriptive tag
docker build --tag=${DOCKER_TAG} --no-cache .

# Step 2: 
# List docker images
docker image ls

# Step 3: 
# Run flask app
docker run -p 8000:80 ${DOCKER_TAG}
