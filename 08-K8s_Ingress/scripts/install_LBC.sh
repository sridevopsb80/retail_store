

export AWS_REGION="us-east-1"
export EKS_CLUSTER_NAME="retail-dev-eks"
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# Confirm values
echo $AWS_REGION
echo $EKS_CLUSTER_NAME
echo $AWS_ACCOUNT_ID