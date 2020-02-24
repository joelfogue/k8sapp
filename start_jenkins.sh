#!/usr/bin/env bash

jenkins-container-instance=`docker ps -a | grep jenkins-container | awk '{print $NF}'`
if [ $jenkins-container-instance=='jenkins-container' ]; then
    echo "jenkins-container is running, lets delete"
        docker rm -f jenkins-container
fi

# images=`docker images | grep dind/jenkins | awk '{print $3}'`
# docker rmi $images

sudo docker run --name jenkins-container -p 8081:8080 \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /home/joel/workspace/k8sapp/jenkins_home:/var/jenkins_home \
dind/jenkins:latest
