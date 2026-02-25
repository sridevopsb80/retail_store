# --------------------------------------------------------------------
# Local values used throughout the EKS configuration
# Helps enforce naming consistency and reduce duplication
# --------------------------------------------------------------------
locals {

  owners = var.business_division # Example: "retail"

  environment = var.environment_name # Example: "dev"

  name = "${local.owners}-${local.environment}" # Standardized naming prefix: "<division>-<env>"

  eks_cluster_name = "${local.name}-${var.cluster_name}" # EKS cluster name used for resource naming and tagging
}