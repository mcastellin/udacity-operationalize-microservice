#!/usr/bin/env bash
# This file tags and uploads an image to Docker Hub

# Assumes that an image is built via `run_docker.sh`

# Step 1:
# Create dockerpath
# dockerpath=<your docker ID/path>
dockerimage=make-prediction:latest
dockerpath=mcastellin/udacity-make-prediction

# Step 2:  
# Authenticate & tag
echo "Docker ID and Image: $dockerpath"
docker login --username $DOCKER_USER -p $DOCKER_PASSWORD
docker tag $dockerimage $dockerpath

# Step 3:
# Push image to a docker repository
docker push $dockerpath
