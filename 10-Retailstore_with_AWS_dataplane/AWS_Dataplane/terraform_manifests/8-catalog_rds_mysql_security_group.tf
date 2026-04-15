# Creating Security Group for RDS MySQL
# data.terraform_remote_state.vpc.outputs.vpc_id # importing sg of vpc from outputs in c3_01
# data.terraform_remote_state.eks.outputs.eks_cluster_security_group_id # importing sg of eks from outputs in c3_02

resource "aws_security_group" "rds_mysql_sg" {
  name        = "${local.name}-rds-mysql-sg"
  description = "Allow MySQL access from EKS cluster"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id # associating rds sg with vpc 

  ingress {
    description = "Allow MySQL from EKS cluster security group"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [
      data.terraform_remote_state.eks.outputs.eks_cluster_security_group_id # only allow eks sg to send traffic. Security Group Referencing
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name}-rds-mysql-sg"
  }
}