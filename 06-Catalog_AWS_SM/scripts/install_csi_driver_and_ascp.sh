echo "==============================="
echo "STEP-1: Install the Secrets Store CSI Driver in the kube-system namespace"
echo "==============================="

echo
echo " Installing CSI Driver "
helm install csi-secrets-store \
  secrets-store-csi-driver/secrets-store-csi-driver \
  --namespace kube-system

echo
echo " List Helm releases in the kube-system namespace "
helm list -n kube-system



echo
echo " Verifying installation status of CSI driver "
helm status csi-secrets-store -n kube-system

echo "==============================="
echo "STEP-2: Install AWS Secrets Manager CSI Driver Provider in the kube-system namespace"
echo "==============================="

echo
echo " Installing ASCP "

helm install secrets-provider-aws \
  aws-secrets-manager/secrets-store-csi-driver-provider-aws \
  --namespace kube-system \
  --set secrets-store-csi-driver.install=false
# assumes csi-driver is already installed. 
# if executing manually, ensure you follow the steps as listed here

echo
echo " Listing Helm releases in the kube-system namespace "

helm list -n kube-system

echo
echo " Verifying installation status of AWS Provider "

helm status secrets-provider-aws -n kube-system

echo
echo " Verifying CSI driver and ASCP are running as daemonsets "

kubectl get daemonset -n kube-system

