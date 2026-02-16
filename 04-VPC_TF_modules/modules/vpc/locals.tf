# Locals Block
locals {
  azs             = slice(data.aws_availability_zones.available.names, 0, 3)
  public_subnets  = [for k, az in local.azs : cidrsubnet(var.vpc_cidr, var.subnet_newbits, k+1)]
  private_subnets = [for k, az in local.azs : cidrsubnet(var.vpc_cidr, var.subnet_newbits, k + 11)]
}

# cidrsubnet - Terraform function used to calculate subnet CIDR blocks from VPC CIDR 
# https://developer.hashicorp.com/terraform/language/functions/cidrsubnet
# cidrsubnet(prefix, newbits, netnum) - syntax of the cidrsubnet function
# skipping 10.0.0.0/24 and 10.0.10.0/24