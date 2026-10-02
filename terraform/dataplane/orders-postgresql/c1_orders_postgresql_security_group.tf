# Security Group for RDS PostgreSQL
# Allow access only from EKS Cluster security group
resource "aws_security_group" "orders_postgresql" {

  name        = "orders-postgresql-sg"
  description = "Security Group for the Catalog Orders PostgresSQL RDS instance"

  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    description = "Allow RDS PostgreSQL from EKS Cluster"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [
      data.terraform_remote_state.eks.outputs.eks_cluster_security_group_id
    ]
  }

  egress {

    description = "Allow all outbound traffic"

    from_port = 0
    to_port   = 0

    protocol = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]

  }

  tags = merge(

    var.tags,

    {

      Name = "orders-postgresql-sg"

    }

  )

}
