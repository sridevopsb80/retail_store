echo "==================================================================="
echo "Adding Helm Repositories for CSI Driver and AWS Provider"
echo "==================================================================="

helm repo add secrets-store-csi-driver https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts
helm repo add aws-secrets-manager https://aws.github.io/secrets-store-csi-driver-provider-aws
helm repo update

echo "==============================="
echo "Listing Helm Repos"
echo "==============================="

helm repo list