# The role and policies defined here give EKS worker nodes (every EC2 instance in the group)
# the minimum permissions to pull images from ECR, log to CloudWatch, join the cluster, 
# attach EBS volumes, and handle VPC networking—without broader access. 
# Additional custom policies can be layered on as needed.


# ------------------------------------------------------------------------------
# IAM Role for EC2 nodes in EKS Managed Node Group (EC2 Worker Nodes)
# ------------------------------------------------------------------------------
resource "aws_iam_role" "eks_nodegroup_role" {
  name = "${local.name}-eks-nodegroup-role"

  # Trust policy: allow EC2 service to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  tags = var.tags
}

# ------------------------------------------------------------------------------
# IAM Policy Attachment: AmazonEKSWorkerNodePolicy
# Grants node group access to the EKS cluster
# ------------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.eks_nodegroup_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

# ------------------------------------------------------------------------------
# IAM Policy Attachment: AmazonEKS_CNI_Policy
# Allows nodes to manage networking (ENIs) via the VPC CNI plugin
# ------------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_nodegroup_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# ------------------------------------------------------------------------------
# IAM Policy Attachment: AmazonEC2ContainerRegistryReadOnly
# Grants nodes permission to pull images from Amazon ECR
# ------------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "eks_ecr_policy" {
  role       = aws_iam_role.eks_nodegroup_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
