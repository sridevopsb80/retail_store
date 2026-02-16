# Terraform VPC Module – Single NAT Gateway Setup

> This module is not published on the Terraform Registry.

## Mapping of files in modules folder from 03-VPC_TF

03-data_sources_and_locals.tf --> datasources.tf and locals.tf

| File in module              | File in 03-VPC_TF |
|-----------------------------|---------|
| `main.tf`                   | `03-vpc_resources.tf` |
| `variables.tf`              | `variables.tf` |
| `outputs.tf`                | `outputs.tf` |
| `datasources-and-locals.tf` | `datasources.tf & locals.tf` |
| `README.md`                 |  |

## Features

- Provisions a *custom VPC* with user-defined CIDR block.
- Public & private subnets across 3 Availability Zones.
- Creates *a single NAT Gateway* for private subnets, instead of one per AZ to reduce cost.
- Manages route tables and subnet associations.
- Exports outputs to integrate with EC2, RDS, EKS etc.

## Notes

* Create *one NAT Gateway* per region when cost savings matter.
* Use `terraform.tfvars` or environment-specific tfvars files to reuse this module across `dev`, `test`, `prod`.
* All private subnets, regardless of AZ, routes outbound traffic through the NAT Gateway.
* Only public subnets route through the Internet Gateway (IGW).
* Enable remote state backend for team collaboration by creating a S3 for backend from 02-S3_Backend.