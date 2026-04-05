echo "==========================================="
echo "Applying all HTTPS manifests"
echo "==========================================="

kubectl apply -R -f ../https_retail_store_k8s_manifests/

echo "==========================================="
echo "Display Ingress from all namespaces"
echo "==========================================="
# Get Ingress and ALB address
kubectl get ingress -A

echo "================================================================"
echo "Verify retail store https instance mode and ip mode Ingress"
echo "================================================================"
# Describe ingress to review rules/annotations
kubectl describe ingress retail-store-http-instance-mode
kubectl describe ingress retail-store-http-ip-mode

# echo "================="
# echo "Delete Ingress"
# echo "================="
# kubectl delete -R -f http_retail_store_k8s_manifests