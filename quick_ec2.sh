#!/bin/bash

REGION="eu-west-1"
AMI_ID="ami-04e7764922e1e3a57"
INSTANCE_TYPE="t3.micro"
KEY_NAME="spraktas"
SECURITY_GROUP_ID="sg-0176ce5ea22452d2e"
IAM_INSTANCE_PROFILE="tf_test_role2"
SUBNET_NAME="Testing-Grounds"

SUBNET_ID=$(aws ec2 describe-subnets \
    --region "$REGION" \
    --filters "Name=tag:Name,Values=$SUBNET_NAME" \
    --query "Subnets[0].SubnetId" \
    --output text)

aws iam add-role-to-instance-profile --instance-profile-name tf_test_role2 --role-name tf_test_role2

# Create the EC2 instance
aws ec2 run-instances \
  --region "$REGION" \
  --image-id "$AMI_ID" \
  --instance-type "$INSTANCE_TYPE" \
  --count 1 \
  --key-name "$KEY_NAME" \
  --security-group-ids "$SECURITY_GROUP_ID" \
  --subnet-id "$SUBNET_ID" \
  --iam-instance-profile Name="$IAM_INSTANCE_PROFILE" \

# Check for errors
if [ $? -ne 0 ]; then
  echo "Error creating EC2 instance."
  exit 1
fi