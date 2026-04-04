echo "==============================="
echo "Setting Environment Variables "
echo "==============================="

export AWS_REGION="us-east-1"
export EKS_CLUSTER_NAME="retail-dev-eks"
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# Confirm values
echo $AWS_REGION
echo $EKS_CLUSTER_NAME
echo $AWS_ACCOUNT_ID

echo "==============================="
echo "Create IAM Permission Policy"
echo "==============================="

echo
echo " Creating IAM Policy to retrieve Secrets for catalog-db-secret "

#This policy grants permission to read one secret (catalog-db-secret) from AWS Secrets Manager

# Change Directory
cd ../iam-policy-json-files

# Create Catalog DB Secret Policy JSON file
cat <<EOF > catalog-db-secret-policy.json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret"
      ],
      "Resource": "arn:aws:secretsmanager:${AWS_REGION}:${AWS_ACCOUNT_ID}:secret:catalog-db-secret*"
    }
  ]
}
EOF

# Create IAM Policy from JSON file
aws iam create-policy \
  --policy-name catalog-db-secret-policy \
  --policy-document file://catalog-db-secret-policy.json


echo "==============================="
echo "Create Trust policy for Role Assumption"
echo "==============================="

echo
echo " Creating Trust policy allowing EKS Pods to assume IAM Role"

# Create Trust Policy that allows EKS Pods to assume role through Pod Identity Agent
cat <<EOF > trust-policy.json
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

echo "==============================="
echo "Create IAM Role for Pod Identity"
echo "==============================="

echo
echo " Creating IAM Role"

aws iam create-role \
  --role-name catalog-db-secrets-role \
  --assume-role-policy-document file://trust-policy.json


echo "==========================================="
echo "Attach the IAM policy to IAM Role"
echo "==========================================="

echo
echo " Attaching the IAM policy to IAM Role"
aws iam attach-role-policy \
  --role-name catalog-db-secrets-role \
  --policy-arn arn:aws:iam::${AWS_ACCOUNT_ID}:policy/catalog-db-secret-policy


echo "==========================================="
echo "Listing Attached Policies to IAM Role"
echo "==========================================="

# Verify attachment
aws iam list-attached-role-policies --role-name catalog-db-secrets-role

