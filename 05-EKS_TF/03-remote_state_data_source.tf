# --------------------------------------------------------------------
# Reference the Remote State from VPC module
# --------------------------------------------------------------------
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "tfstate-dev-us-east-1-zfwwag" # Name of the remote S3 bucket where the VPC state is stored
    key    = "dev/vpc/terraform.tfstate"    # Path to the VPC tfstate file within the bucket
    region = var.aws_region                 # Region where the S3 bucket and DynamoDB table exist
  }
}



# --------------------------------------------------------------------
# Reference outputs from the remote VPC state
# --------------------------------------------------------------------

# VPC ID 
output "vpc_id" {
  value = data.terraform_remote_state.vpc.outputs.vpc_id
}

# List of private subnets from VPC

output "private_subnet_ids" {
  value = data.terraform_remote_state.vpc.outputs.private_subnet_ids
}

# List of public subnets from VPC

output "public_subnet_ids" {
  value = data.terraform_remote_state.vpc.outputs.public_subnet_ids
}

