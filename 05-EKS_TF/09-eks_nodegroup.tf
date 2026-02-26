# EKS Managed Node Group - Private Subnets


resource "aws_eks_node_group" "private_nodes" {

  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${local.name}-private-ng"
  node_role_arn   = aws_iam_role.eks_nodegroup_role.arn
  subnet_ids      = data.terraform_remote_state.vpc.outputs.private_subnet_ids
  instance_types  = var.node_instance_types
  capacity_type   = var.node_capacity_type
  ami_type        = "AL2023_x86_64_STANDARD"
  disk_size       = var.node_disk_size

  # Configure auto-scaling
  scaling_config {
    desired_size = 3
    min_size     = 1
    max_size     = 6
  }

  # Set the max percentage of nodes that can be unavailable during update
  update_config {
    max_unavailable_percentage = 33
  }

  # Force node group update when EKS AMI version changes - disable for prod
  force_update_version = true

  # Apply labels to each EC2 instance for easier scheduling and management in Kubernetes
  labels = {
    "env"      = var.environment_name
    "division" = var.business_division
  }

  # Tags for the node group and associated EC2 instances
  tags = merge(var.tags, {
    Name        = "${local.name}-private-ng"
    Environment = var.environment_name
  })

  # Ensure IAM role policies are attached before creating the node group
  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.eks_ecr_policy
  ]
}
