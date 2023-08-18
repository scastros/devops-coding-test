#!/bin/sh

#########################
# run.sh
# 
# This script will run the Docker container created with build script.
#########################

# Mapping the port and indicating container name
docker run -p 8443:8443 -d --name MegaDemo demo-app:latest 
# Waiting for port avalability and testing
while ! curl --output /dev/null --silent --head --fail http://localhost:8443/; do sleep 1 && echo -n .; done;
curl -X GET localhost:8443/