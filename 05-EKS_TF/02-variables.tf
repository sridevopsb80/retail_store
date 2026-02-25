# --------------------------------------------------------
# AWS Region 
# --------------------------------------------------------
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

# --------------------------------------------------------
# Environment Info
# --------------------------------------------------------

variable "environment_name" {
  description = "Environment name used in resource names and tags"
  type        = string
  default     = "dev"
}

# Business unit or department info
variable "business_division" {
  description = "Business Division in the organization this infrastructure belongs to"
  type        = string
  default     = "retail"
}

# --------------------------------------------------------
# EKS Cluster Configuration
# --------------------------------------------------------

# Name of the EKS cluster 
variable "cluster_name" {
  description = "Name of the EKS cluster. To be used as a prefix in names of related resources."
  type        = string
  default     = "eks"
}

# Kubernetes version for the EKS control plane
variable "cluster_version" {
  description = "Leave it as null to use AWS default"
  type        = string
  default     = null # AWS sets the default value
}

# CIDR block used for Kubernetes service networking
variable "cluster_service_ipv4_cidr" {
  description = "CIDR range for Kubernetes services communication. Leave it as null to use AWS default."
  type        = string
  default     = null # AWS sets the default value
}

# Disable access to the EKS API via private endpoint - enable in prod
variable "cluster_endpoint_private_access" {
  description = "Disable private access to EKS control plane endpoint (kubeapi server)"
  type        = bool
  default     = false
}

# Enable access to the EKS API via public endpoint - disable in prod
variable "cluster_endpoint_public_access" {
  description = "Enable public access to EKS control plane endpoint (kubeapi server)"
  type        = bool
  default     = true
}

# List of CIDRs allowed to reach the public EKS API endpoint from public internet
# Narrow this down to specific IPs or subnet ranges for prod as needed

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks allowed to access public EKS endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# --------------------------------------------------------
# Tags applied to all resources created by this configuration
# --------------------------------------------------------

variable "tags" {
  description = "Tags to apply to EKS and related resources"
  type        = map(string)
  default = {
    Terraform = "true"
    Owner     = "DevOps Team"
  }
}

# --------------------------------------------------------
# EKS Node Group Configuration
# --------------------------------------------------------

# EC2 instance types for worker nodes
variable "node_instance_types" {
  description = "List of EC2 instance types for the node group"
  type        = list(string)
  default     = ["t3.medium"]
}

# Capacity type for node group (ON_DEMAND or SPOT)
variable "node_capacity_type" {
  description = "Instance capacity type: ON_DEMAND or SPOT"
  type        = string
  default     = "ON_DEMAND"
}

# Root volume size (GiB) for worker nodes
variable "node_disk_size" {
  description = "Disk size in GiB for worker nodes"
  type        = number
  default     = 20
}
