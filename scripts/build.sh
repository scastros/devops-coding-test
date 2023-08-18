#!/bin/sh

#########################
# build.sh
# 
# This script will compile the Spring Boot application and 
# create the Docker image.
#########################

# Checking installed Java version to be at least 11
JAVA_VER=`java -version 2>&1 | grep -oP 'version "?(1\.)?\K\d+'`

if [ "$JAVA_VER" != "11" ]; then                
     echo Java version $JAVA_VER is not compatible with this program. Please install at least Java 11.
     exit
fi

# This is the port where the server will start
SERVER_PORT=8443

# .mvn folder is not in the provided repository, so we are
# assuming that we have Maven installed, and going to 
# install Maven wrapper dependencies 
mvn wrapper:wrapper

# Now compiling project and installing dependencies trough provided Maven wrapper
./mvnw install

# Running
nohup ./mvnw spring-boot:run &
echo $! > command.pid

# To test if the app is up and running, we have added the Spring Boot actuator
# dependency to pom.xml file to check app health:
#       [...]
#		<dependency>
#			<groupId>org.springframework.boot</groupId>
#			<artifactId>spring-boot-starter-actuator</artifactId>
#		</dependency>
#       [...]
# If needed, we can use this actuator later in the docker healthcheck.
#
# Now we can check app status. If the actuator returns UP, we kill the process
# and we can continue building the docker image.
curl --fail --silent localhost:$SERVER_PORT/actuator/health | grep UP || kill -9 $(cat command.pid)

echo "Building Docker Image..."

docker build -f scripts/Dockerfile --tag=demo-app:latest .

# Checking if the image is built
docker image ls -a demo-app:latest
