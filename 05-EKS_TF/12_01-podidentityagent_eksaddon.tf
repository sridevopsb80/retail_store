# Refer https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_addon_version

# Datasource: To get default EKS addon version compatible with EKS cluster version
data "aws_eks_addon_version" "pia_default" {
  addon_name         = "eks-pod-identity-agent"
  kubernetes_version = aws_eks_cluster.main.version
}

# Datasource: To get latest EKS addon version compatible with EKS cluster version
data "aws_eks_addon_version" "pia_latest" {
  addon_name         = "eks-pod-identity-agent"
  kubernetes_version = aws_eks_cluster.main.version
  most_recent        = true
}

# Refer https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon

# EKS Addon: Pod Identity Agent
resource "aws_eks_addon" "podidentity" {
  depends_on = [aws_eks_node_group.private_nodes]  # refer 09-eks_nodegroup
  cluster_name                = aws_eks_cluster.main.id
  addon_name                  = "eks-pod-identity-agent"
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  # Use the latest EKS addon version compatible with the cluster's Kubernetes version
  addon_version               = data.aws_eks_addon_version.pia_latest.version
}


# Outputs
output "pod_identity_agent_eksaddon_default_version" {
  value = data.aws_eks_addon_version.pia_default.version
}

output "pod_identity_agent_eksaddon_latest_version" {
  value = data.aws_eks_addon_version.pia_latest.version
}

output "pod_identity_agent_eksaddon_arn" {
  value = aws_eks_addon.podidentity.arn
}  

output "pod_identity_agent_eksaddon_id" {
  value = aws_eks_addon.podidentity.id
}
# ID Format - <cluster_name>:<addon_name> - eks:eks-pod-identity-agent