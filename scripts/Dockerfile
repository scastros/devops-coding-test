FROM openjdk:11-jre-slim

# Install curl to test later the SpringBoot response
RUN apt-get update 
RUN apt-get install -y gcc
RUN apt-get install -y curl

EXPOSE 8443

COPY target/demo-0.0.1-SNAPSHOT.jar demo-1.0.0.jar
ENTRYPOINT ["java","-jar","/demo-1.0.0.jar"]