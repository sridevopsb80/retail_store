
echo "==============================="
echo "Set Environment Variables"
echo "==============================="


export AWS_REGION="us-east-1"
export EKS_CLUSTER_NAME="retail-dev-eksdemo1"
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# Confirm values
echo $AWS_REGION
echo $EKS_CLUSTER_NAME
echo $AWS_ACCOUNT_ID


echo 
echo " Done "

echo "==============================="
echo "Creating Trust Policy file"
echo "==============================="

# Create Trust Policy file
# Lets EKS Pods (via Pod Identity Agent) assume the role

cd ../iam-policy-json-files

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

echo 
echo " Done "

echo "==============================="
echo "Create IAM Role and Attach AmazonEBSCSIDriverPolicy Policy"
echo "==============================="

echo 
echo " Creating IAM Role "

aws iam create-role \
  --role-name AmazonEKS_EBS_CSI_DriverRole_${EKS_CLUSTER_NAME} \
  --assume-role-policy-document file://ebs-csi-driver-trust-policy.json

echo 
echo " Done "

echo 
echo " Attaching IAM Policy to IAM Role "

aws iam attach-role-policy \
  --role-name AmazonEKS_EBS_CSI_DriverRole_${EKS_CLUSTER_NAME} \
  --policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy

echo 
echo " Done "

echo 
echo " Listing IAM Policies attached to Role for verification  "
# 
aws iam list-attached-role-policies \
  --role-name AmazonEKS_EBS_CSI_DriverRole_${EKS_CLUSTER_NAME}

echo "==============================="
echo "Create Pod Identity Association"
echo "==============================="

echo 
echo " Creating EKS Pod Identity Assocication  "

aws eks create-pod-identity-association \
  --cluster-name ${EKS_CLUSTER_NAME} \
  --namespace kube-system \
  --service-account ebs-csi-controller-sa \
  --role-arn arn:aws:iam::${AWS_ACCOUNT_ID}:role/AmazonEKS_EBS_CSI_DriverRole_${EKS_CLUSTER_NAME}

echo "==============================="
echo "Install the EBS CSI Driver Add-on"
echo "==============================="

echo 
echo " Listing existing EKS add-ons  "

aws eks list-addons --cluster-name ${EKS_CLUSTER_NAME}

echo 
echo " Installing EKS EBS CSI Addon and associate it with the IAM Role created earlier"

aws eks create-addon \
  --cluster-name ${EKS_CLUSTER_NAME} \
  --addon-name aws-ebs-csi-driver \
  --service-account-role-arn arn:aws:iam::${AWS_ACCOUNT_ID}:role/AmazonEKS_EBS_CSI_DriverRole_${EKS_CLUSTER_NAME}

echo 
echo " Done "

echo 
echo " Verify Installation "

# List EKS add-ons (after install)
aws eks list-addons --cluster-name ${EKS_CLUSTER_NAME}


# # Describe Addon - Verify Status
# aws eks describe-addon \
#   --cluster-name ${EKS_CLUSTER_NAME} \
#   --addon-name aws-ebs-csi-driver \
#   --query "addon.status" --output text



# kubectl get pods -n kube-system | grep ebs-csi
# kubectl get ds   -n kube-system | grep ebs-csi
# kubectl get deploy -n kube-system | grep ebs-csi