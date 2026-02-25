# ------------------------------------------------------------------------------
# IAM Role for EKS Control Plane
# Required so the EKS control plane can manage AWS infrastructure resources
# (networking, security groups, ENIs, load balancers, etc.)
# ------------------------------------------------------------------------------
resource "aws_iam_role" "eks_cluster" {
  name = "${local.name}-eks-cluster-role"

  # Trust policy to allow EKS service to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })

  tags = var.tags
}

# ------------------------------------------------------------------------------
# Attach AmazonEKSClusterPolicy
# Grants EKS permissions to manage required AWS infrastructure resources
# ------------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# ------------------------------------------------------------------------------
# Attach AmazonEKSVPCResourceController
# Enables advanced VPC networking features such as security groups for pods
# and enhanced ENI/IP management
# ------------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "eks_vpc_resource_controller" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}
