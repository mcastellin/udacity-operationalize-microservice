#!/usr/bin/env bash

# This tags and uploads an image to Docker Hub

# Step 1:
# This is your Docker ID/path
dockerpath=mcastellin/udacity-make-prediction

# Step 2
# Run the Docker Hub container with kubernetes
kubectl run makepredictionapp\
  --generator=run-pod/v1\
  --image=$dockerpath\
  --port 80\
  --labels run=makepredictionapp


# Step 3:
# List kubernetes pods
kubectl get pods

# Step 3.1:
# Wait for pod to be ready
ready="false"
while [ "$ready" != "true" ]; do 
  echo "Waiting for pod to be ready... "
  sleep 2
  ready=$(kubectl get pod makepredictionapp\
    -o go-template="{{(index .status.containerStatuses 0).ready}}")
done
echo "Pod is ready."

# Step 4:
# Forward the container port to a host
kubectl port-forward makepredictionapp 8000:80

