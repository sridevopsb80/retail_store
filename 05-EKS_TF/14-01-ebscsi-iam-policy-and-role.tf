# provision ebs csi driver related resources for ebs volume administration

# Create IAM Role for EBS CSI Driver
resource "aws_iam_role" "ebs_csi_iam_role" {
  name = "${local.name}-ebs-csi-iam-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = {
    Name        = "${local.name}-ebs-csi-iam-role"
    Environment = var.environment_name
    Component   = "Amazon EBS CSI Driver"
  }
}

# Attach AWS Managed Policy for EBS CSI Driver
resource "aws_iam_role_policy_attachment" "ebs_csi_managed_policy_attach" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy" # AWS managed policy
  role       = aws_iam_role.ebs_csi_iam_role.name
}

# Output: IAM Role ARN
output "ebs_csi_iam_role_arn" {
  description = "IAM Role ARN for Amazon EBS CSI Driver"
  value       = aws_iam_role.ebs_csi_iam_role.arn
}
