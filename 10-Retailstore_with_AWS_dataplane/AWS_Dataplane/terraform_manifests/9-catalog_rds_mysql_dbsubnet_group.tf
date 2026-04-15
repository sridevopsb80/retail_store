# DB Subnet Group (using private subnets from VPC project)
# data.terraform_remote_state.vpc.outputs.private_subnet_ids # importing sg of vpc from outputs in c3_01

resource "aws_db_subnet_group" "rds_private" {
  name       = "${local.name}-rds-private-subnets"
  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnet_ids

  tags = {
    Name = "${local.name}-rds-private-subnets"
  }
}