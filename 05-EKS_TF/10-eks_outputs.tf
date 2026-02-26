# ------------------------------------------------------------------------------
# EKS Cluster API server endpoint
# Used by kubectl and external tools to communicate with the cluster
# ------------------------------------------------------------------------------
output "eks_cluster_endpoint" {
  value       = aws_eks_cluster.main.endpoint
  description = "EKS API server endpoint"
}

# ------------------------------------------------------------------------------
# EKS Cluster ID
# Used in AWS CLI commands and automation scripts to reference the EKS cluster
# ------------------------------------------------------------------------------
output "eks_cluster_id" {
  description = "The name/id of the EKS cluster"
  value       = aws_eks_cluster.main.id
}

# ------------------------------------------------------------------------------
# EKS Cluster Version
# ------------------------------------------------------------------------------
output "eks_cluster_version" {
  description = "EKS Kubernetes version"
  value       = aws_eks_cluster.main.version
}

# ------------------------------------------------------------------------------
# Name of the EKS cluster
# Helpful for scripting, `aws eks update-kubeconfig`, etc.
# ------------------------------------------------------------------------------
output "eks_cluster_name" {
  value       = aws_eks_cluster.main.name
  description = "EKS cluster name"
}


# ------------------------------------------------------------------------------
# EKS Cluster Certificate Authority data
# Needed when setting up kubeconfig or accessing EKS via API
# ------------------------------------------------------------------------------
output "eks_cluster_certificate_authority_data" {
  value       = aws_eks_cluster.main.certificate_authority[0].data
  description = "Base64 encoded CA certificate for kubectl config"
}

# ------------------------------------------------------------------------------
# Logical name of the private node group
# Useful for autoscaler configs, dashboards, tagging
# ------------------------------------------------------------------------------
output "private_node_group_name" {
  value       = aws_eks_node_group.private_nodes.node_group_name
  description = "Name of the EKS private node group"
}

# ------------------------------------------------------------------------------
# IAM Role ARN used by the EKS Node Group
# Useful for IRSA setup or attaching additional permissions
# ------------------------------------------------------------------------------
output "eks_node_instance_role_arn" {
  value       = aws_iam_role.eks_nodegroup_role.arn
  description = "IAM Role ARN used by EKS node group (EC2 worker nodes)"
}

# ------------------------------------------------------------------------------
# Command to configure kubectl for this EKS cluster
# Run directly after apply
# ------------------------------------------------------------------------------
output "to_configure_kubectl" {
  description = "Command to update local kubeconfig to connect to the EKS cluster"
  value       = "aws eks --region ${var.aws_region} update-kubeconfig --name ${local.eks_cluster_name}"
}


