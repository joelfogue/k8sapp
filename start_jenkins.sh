#!/usr/bin/env bash

sudo docker run --name jenkins-container -p 8081:8080 \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /home/joel/workspace/k8sapp/jenkins_home:/var/jenkins_home \
dind/jenkins:latest
