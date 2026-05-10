# EKS pods need IAM Policy, IAM role, EKS PIA association, Service Account 
# for the service to access the secrets stored in AWS Secrets Manager.


# IAM Role for Pod Identity (to access AWS Secrets Store CSI Driver) - will be assumed by pods
resource "aws_iam_role" "catalog_getsecrets" {
  name               = "${local.name}-catalog-getsecrets-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json 
  # refer 6-podidentity_assumerole_policy.tf for IAM policy

  tags = {
    Name        = "${local.name}-catalog-getsecrets-role"
    Environment = var.environment_name
    Component   = "AWS Secrets Store CSI Driver ASCP"
  }
}

# Attach IAM Policy retailstore_db_secret_policy to Role 
# to allow access to all retailstore-db-secrets
resource "aws_iam_role_policy_attachment" "catalog_db_secret_attach" {
  policy_arn = aws_iam_policy.retailstore_db_secret_policy.arn # refer 7-secretstorecsi_iam_policy
  role       = aws_iam_role.catalog_getsecrets.name # refer resource above
}

# Outputs
output "catalog_sa_getsecrets_role_arn" {
  description = "IAM Role ARN for Catalog PostgreSQL Get Secrets from AWS Secrets Manager"
  value       = aws_iam_role.catalog_getsecrets.arn
}
