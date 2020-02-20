#!/bin/bash
sed "s/tag/$1/g" ../app/pods.yml > nginx-pod.yml