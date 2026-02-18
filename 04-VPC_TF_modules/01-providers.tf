terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }
  }
  # Remote Backend
  backend "s3" {
    bucket       = "tfstate-dev-us-east-1-zfwwag" #s3 bucket created from 02 folder
    key          = "dev/vpc/terraform.tfstate"    #define where you want tfstate to be stored
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true #enable state locking
  }
}

provider "aws" {
  region = var.aws_region
}


