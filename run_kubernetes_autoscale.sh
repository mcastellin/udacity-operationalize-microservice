#!/usr/bin/env bash

# Run the Docker Hub container with kubernetes
kubectl apply -f api/deploy.yaml

# List kubernetes pods
kubectl get pods

# Wait for frontend pod to be ready
ready="false"
while [ "$ready" != "true" ]; do 
  echo "Waiting for pod to be ready... "
  sleep 2
  ready=$(kubectl get pods -l run=makeprediction-api\
    -o go-template="{{(index (index .items 0).status.containerStatuses 0).ready}}")
done
echo "Pod is ready."

# Listing kubernetes pods after application is ready
kubectl get pods

# Configuring k8s autoscale
kubectl autoscale deployment makeprediction-api --cpu-percent=50 --min=1 --max=10

# Listing kubernetes horizontal pod autoscalers
kubectl get hpa

# Forward the container port to a host
kubectl port-forward service/makeprediction-api 8000:80

