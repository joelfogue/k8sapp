#!/bin/bash
sed "s/tag/$1/g" ~/k8sapp/app/pods.yml >~/k8sapp/app/nginx-pod.yml