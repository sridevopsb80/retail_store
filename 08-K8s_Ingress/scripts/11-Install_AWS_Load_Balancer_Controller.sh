echo "==========================================="
echo "Adding Helm Repo for eks charts and Update"
echo "==========================================="

helm repo add eks https://aws.github.io/eks-charts
helm repo update

echo "==========================================="
echo "Installing Load Balancer Controller"
echo "==========================================="

echo "Verify VPC_ID"

# Get VPC ID
VPC_ID=$(aws eks describe-cluster \
  --name ${EKS_CLUSTER_NAME} \
  --query "cluster.resourcesVpcConfig.vpcId" \
  --output text)

# Display VPC ID
echo $VPC_ID

echo "Installing AWS LBC using Helm"

# Install AWS Load Balancer Controller using HELM
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=${EKS_CLUSTER_NAME} \
  --set region=${AWS_REGION} \
  --set vpcId=${VPC_ID} \
  --set serviceAccount.create=true \
  --set serviceAccount.name=aws-load-balancer-controller  

echo "==========================================="
echo "Verify Load Balancer Controller is installed"
echo "==========================================="

echo "Listing Helm Packages in kube-system namespace"

helm list -n kube-system

echo "Verifying Controller Deployment"

kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller

