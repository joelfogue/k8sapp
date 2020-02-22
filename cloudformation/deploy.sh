#!/usr/bin/env bash

AWS_ACCOUNT="113053198971"
AWS_ACCOUNT_PROFILE="saml"
REGION="us-east-1"
STACK_NAME="ami-test"


echo -n "Creating ec2 from packer ami > "
aws cloudformation deploy \
--stack-name $STACK_NAME \
--template-file template.yaml \
--capabilities CAPABILITY_NAMED_IAM \
--parameter-overrides AWS_ACCOUNT=$AWS_ACCOUNT \
--profile $AWS_ACCOUNT_PROFILE \
--region=$REGION
