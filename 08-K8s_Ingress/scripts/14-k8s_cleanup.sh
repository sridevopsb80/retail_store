#!/bin/bash
set -e

echo "================="
echo "Delete HTTP Ingress"
echo "================="
kubectl delete -R -f http_retail_store_k8s_manifests

echo "================="
echo "Delete HTTPS Ingress"
echo "================="
kubectl delete -R -f http_retail_store_k8s_manifests

# # List nodes
# kubectl get nodes

# # Drain nodes
# kubectl drain <node-name> --ignore-daemonsets --delete-emptydir-data

# # TF Destroy node groups only first
# terraform destroy -target=aws_eks_node_group.<your_node_group_name>

# # Delete EKS Cluster
# terraform destroy -target=aws_eks_cluster.<your_cluster_name>

# Destroy remaining infra
terrafrom destroy