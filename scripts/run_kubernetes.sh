#!/usr/bin/env bash

# This tags and uploads an image to Docker Hub

# Step 1:
# This is your Docker ID/path
dockerpath=aanorbel/ud-nd9991-capstone:latest

# Step 2
# Run the Docker Hub container with kubernetes
kubectl run ud-nd9991-capstone\
    --image=$dockerpath\
    --port=8000 --labels app=capstone-udacity

# Wait to pod status will be ready
kubectl wait pod/ud-nd9991-capstone --for=condition=Ready --timeout=-1s

# Step 3:
# List kubernetes pods
kubectl get pods

# Step 4:
# Forward the container port to a host
kubectl port-forward ud-nd9991-capstone 8000:8000

# Step 5:
# See the output of app running into pods
kubectl logs ud-nd9991-capstone  