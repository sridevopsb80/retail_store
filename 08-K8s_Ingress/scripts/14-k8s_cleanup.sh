
# List nodes
kubectl get nodes


# Drain nodes
kubectl drain <node-name> --ignore-daemonsets --delete-emptydir-data

# TF Destroy node groups only first
terraform destroy -target=aws_eks_node_group.<your_node_group_name>

# Delete EKS Cluster
terraform destroy -target=aws_eks_cluster.<your_cluster_name>

# Destroy remaining infra
terrafrom destroy