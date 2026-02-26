# ------------------------------------------------------------------------------
# Create the Control plane of AWS EKS Cluster

# Note: enable private access endpoint and disable public access endpoint for prod builds
# ------------------------------------------------------------------------------
resource "aws_eks_cluster" "main" {

  name     = local.eks_cluster_name
  version  = var.cluster_version
  role_arn = aws_iam_role.eks_cluster.arn

  # VPC configuration for control plane networking
  vpc_config {
    subnet_ids              = data.terraform_remote_state.vpc.outputs.private_subnet_ids
    endpoint_private_access = var.cluster_endpoint_private_access
    endpoint_public_access  = var.cluster_endpoint_public_access
    public_access_cidrs     = var.cluster_endpoint_public_access_cidrs
  }

  # Define the service CIDR range used by Kubernetes services 
  kubernetes_network_config {
    service_ipv4_cidr = var.cluster_service_ipv4_cidr
  }

  # Enable EKS control plane logging for visibility and debugging
  enabled_cluster_log_types = [
    "api",               # API server audit logs
    "audit",             # Kubernetes audit logs
    "authenticator",     # Authenticator logs for IAM auth
    "controllerManager", # Logs for controller manager
    "scheduler"          # Logs for pod scheduling
  ]

  # Ensure IAM policy attachments complete before cluster creation
  # Helps avoid race conditions during provisioning and destroy
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_vpc_resource_controller
  ]

  # Common tags applied to the EKS cluster
  tags = var.tags

  # ----------------------------------------------------------------------------
  # Access Config – How we control who can access our EKS cluster
  # # Three options for authentication: CONFIG_MAP, API, API_AND_CONFIG_MAP
  # ----------------------------------------------------------------------------
  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

}


