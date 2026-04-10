#!/bin/bash
set -e

echo "==========================================="
echo "Applying all HTTP manifests"
echo "==========================================="

kubectl apply -R -f ../http_retail_store_k8s_manifests/

echo "==========================================="
echo "Display Ingress from all namespaces"
echo "==========================================="
# Get Ingress and ALB address
kubectl get ingress -A

echo "================================================================"
echo "Verify retail store http instance mode and ip mode Ingress"
echo "================================================================"
# Describe ingress to review rules/annotations
kubectl describe ingress retail-store-http-instance-mode
kubectl describe ingress retail-store-http-ip-mode

# echo "================="
# echo "Delete Ingress"
# echo "================="
# kubectl delete -R -f http_retail_store_k8s_manifests