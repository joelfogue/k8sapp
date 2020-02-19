#!/usr/bin/env bash

export AWS_DEFAULT_REGION="us-east-1"

## Provisioning EKS
echo -e "Creating keypair..."

## Provisioning EKS
aws ec2 create-key-pair --key-name "$1-keypair" --query 'KeyMaterial' --output text > ~/.ssh/$1-keypair.pem

## Provisioning EKS
eksctl create cluster \
--name "$1-EKS" \
--version 1.13 \
--nodegroup-name "$1-workers" \
--node-type t3.2xlarge \
--nodes 3 \
--node-ami auto  \
--node-volume-size 35 \
--max-pods-per-node 200 \
--ssh-access \
--ssh-public-key "$1-keypair"
--zones "us-east-1a,us-east-1b"
# --vpc-private-subnets=subnet-0483061165e5c6b42,subnet-0ea076023837d5b52
# --vpc-public-subnets=subnet-0109de58319e6b483,subnet-06c9bcca27f028ca8

## Getting SG,SUBNET
echo -e "Getting SG, SUBNET..."
SG=$(aws eks describe-cluster --name "$1-EKS" --query "cluster.resourcesVpcConfig.securityGroupIds[0]" | sed 's/\"//g')
WSG=$(aws ec2 describe-security-groups --group-ids $SG --query SecurityGroups[0].IpPermissionsEgress[0].UserIdGroupPairs[0].GroupId|sed 's/\"//g')
VPC=$(aws eks describe-cluster --name "$1-EKS" --query "cluster.resourcesVpcConfig.vpcId" | sed 's/\"//g')
SUBNET=$(aws eks describe-cluster --name "$1-EKS" --query "cluster.resourcesVpcConfig.subnetIds[0]"| sed 's/\"//g')

## Configuring SG
echo -e "Configuring SG"
aws ec2 authorize-security-group-ingress --group-id $SG --protocol tcp --port 988 --cidr 172.31.0.0/16
aws ec2 authorize-security-group-ingress --group-id $SG --protocol tcp --port 988 --cidr 192.168.0.0/16
aws ec2 authorize-security-group-ingress --group-id $WSG --protocol tcp --port 988 --cidr 172.31.0.0/16
aws ec2 authorize-security-group-ingress --group-id $WSG --protocol tcp --port 988 --cidr 192.168.0.0/16

## Create FSx
echo -e "Creating FSx..."
aws fsx create-file-system \
      --client-request-token "$1" \
      --file-system-type LUSTRE \
      --storage-capacity 1200 \
      --tags Key="Name",Value="Lustre-$1" \
      --subnet-ids "$SUBNET" \
      --security-group-ids $SG $WSG
 
 ## Getting FSx
 echo -e "Getting FSx"
FSX=$(aws fsx describe-file-systems --query 'FileSystems[*].{FileSystemId:FileSystemId,Tags:Tags[0].Value==`'Lustre-$1'`}' --output text  | grep True| awk '{print $1}')

echo -e "kubernetes_cluster_name: $1-EKS"
echo -e "fsx_file_system_id: $FSX"
echo -e "fsx_region: us-east-1"
echo -e "ssh_key path is: ~/.ssh/$1-keypair.pem"
