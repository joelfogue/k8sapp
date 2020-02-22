#!/usr/bin/env bash

REGION="us-east-1"
CLUSTER_NAME="turkeytest.k8sapp.com"
BUCKET_NAME="s3://ami-test-bucket-hz"
EC2_TYPE="t2.medium"

export AWS_DEFAULT_REGION=${REGION}

## Provisioning EKS
echo -e "Creating keypair..."

## Provisioning EKS
aws ec2 create-key-pair --key-name "$1-keypair" --query 'KeyMaterial' --output text > ~/.ssh/$1-keypair.pem 
chmod 600 ~/.ssh/$1-keypair.pem 

# echo 'export KOPS_CLUSTER_NAME='${CLUSTER_NAME} >> ~/.bashrc
# echo 'export KOPS_STATE_STORE='${BUCKET_NAME} >> ~/.bashrc

# # Doing this multiple times to ensure it gets run
# source /home/ubuntu/.bashrc
# source ~/.bashrc 
# source ~/.bashrc 

## create cluster 
kops create cluster \
--state=${KOPS_STATE_STORE} \
--node-count=2 \
--master-size=t2.medium \
--node-size=t2.medium \
--zones=us-east-1a,us-east-1b \
--name=${KOPS_CLUSTER_NAME} \
--dns private \
--master-count 1

kops update cluster --yes
