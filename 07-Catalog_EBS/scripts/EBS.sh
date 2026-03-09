# Export Environment Variables

export AWS_REGION="us-east-1"
export EKS_CLUSTER_NAME="retail-dev-eksdemo1"
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# Confirm values
echo $AWS_REGION
echo $EKS_CLUSTER_NAME
echo $AWS_ACCOUNT_ID

# Create Trust Policy file

cd iam-policy-json-files

cat <<EOF > ebs-csi-driver-trust-policy.json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "pods.eks.amazonaws.com"
      },
      "Action": [
        "sts:AssumeRole",
        "sts:TagSession"
      ]
    }
  ]
}
EOF

# Create IAM Role and Attach Policy

# Create IAM Role
aws iam create-role \
  --role-name AmazonEKS_EBS_CSI_DriverRole_${EKS_CLUSTER_NAME} \
  --assume-role-policy-document file://ebs-csi-driver-trust-policy.json

# Attach IAM Policy to IAM Role
aws iam attach-role-policy \
  --role-name AmazonEKS_EBS_CSI_DriverRole_${EKS_CLUSTER_NAME} \
  --policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy

# Verify:
aws iam list-attached-role-policies \
  --role-name AmazonEKS_EBS_CSI_DriverRole_${EKS_CLUSTER_NAME}

# Create Pod Identity Association (required for CLI install)