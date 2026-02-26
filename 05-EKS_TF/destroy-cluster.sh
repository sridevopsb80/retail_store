#!/bin/bash
set -e

echo "==============================="
echo "STEP-1: Destroy EKS Cluster"
echo "==============================="
terraform destroy -auto-approve

echo
echo " Cleaning up local Terraform cache..."
rm -rf .terraform .terraform.lock.hcl

echo
echo "==============================="
echo "STEP-2: Destroy VPC"
echo "==============================="
cd ../04-VPC_TF_modules
terraform destroy -auto-approve

echo
echo " Cleaning up local Terraform cache..."
rm -rf .terraform .terraform.lock.hcl

echo
echo " EKS Cluster and VPC destroyed and cleaned up successfully!"
