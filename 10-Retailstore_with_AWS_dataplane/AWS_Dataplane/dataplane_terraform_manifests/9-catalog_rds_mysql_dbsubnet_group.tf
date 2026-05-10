# Create DB Subnet Group (using private subnets from VPC) 

resource "aws_db_subnet_group" "rds_private" {
  name       = "${local.name}-rds-private-subnets"
  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnet_ids 
  # importing private subnet id of vpc from vpc outputs

  tags = {
    Name = "${local.name}-rds-private-subnets"
  }
}