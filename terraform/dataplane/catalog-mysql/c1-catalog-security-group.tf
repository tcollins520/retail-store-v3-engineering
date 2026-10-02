resource "aws_security_group" "catalog_mysql" {

  name        = "catalog-mysql-sg"
  description = "Security Group for the Catalog MySQL Amazon RDS instance"

  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {

    description = "Allow MySQL traffic from Amazon EKS"

    from_port = 3306
    to_port   = 3306

    protocol = "tcp"

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

      Name = "catalog-mysql-sg"

    }

  )

}