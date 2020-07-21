#!/usr/bin/env bash

## Complete the following steps to get Docker running locally

# Step 1:
# Build image and add a descriptive tag
docker build . -t ud-nd9991-capstone

# Step 2: 
# List docker images
docker images | grep ud-nd9991-capstone

# Step 3: 
# Run flask app
docker run --env-file .env -p 8000:8000 ud-nd9991-capstone