#!/bin/bash
set -e

echo "==============================="
echo "Setting Environment Variables"
echo "==============================="

export AWS_REGION="us-east-1"
export EKS_CLUSTER_NAME="retail-dev-eks"
export AGENT_VERSION="v1.3.10-eksbuild.2"

# Confirm values
echo $AWS_REGION
echo $EKS_CLUSTER_NAME
echo $AGENT_VERSION

echo "==============================="
echo "Create EKS Pod-Identity Agent"
echo "==============================="

aws eks create-addon \
    --cluster-name $EKS_CLUSTER_NAME \
    --region $AWS_REGION \
    --addon-name eks-pod-identity-agent \
    --addon-version $AGENT_VERSION \
    --resolve-conflicts OVERWRITE