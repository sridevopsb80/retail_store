terraform {
  # Minimum Terraform CLI version required
  required_version = ">= 1.12.0"

  # Required providers and version constraints
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }
  }

  # Remote backend configuration using S3 
    backend "s3" {
    bucket       = "tfstate-dev-us-east-1-zfwwag" #replace with s3 bucket created from 02 folder
    key          = "dev/eks/terraform.tfstate"    #define where you want tfstate to be stored
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true #enable state locking
  }
}

provider "aws" {
  # AWS region to use for all resources (from variables)
  region = var.aws_region
}