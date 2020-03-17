#!/usr/bin/env bash

# This script deploys the kubernetes cluster with the frontend and backend apps.

kubectl apply -f api/deploy.yaml -f frontend/deploy.yaml

# List kubernetes pods
kubectl get pods

# Wait for frontend pod to be ready
ready="false"
while [ "$ready" != "true" ]; do 
  echo "Waiting for pod to be ready... "
  sleep 2
  ready=$(kubectl get pods -l run=makeprediction-frontend\
    -o go-template="{{(index (index .items 0).status.containerStatuses 0).ready}}")
done
echo "Pod is ready."

# Listing kubernetes pods after application is ready
kubectl get pods

# Forward the container port to a host
kubectl port-forward service/makeprediction-frontend 8080:80
