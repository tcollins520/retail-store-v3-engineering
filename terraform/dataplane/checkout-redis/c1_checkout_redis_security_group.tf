# ------------------------------------------------------------------------------
# Security Group for Amazon ElastiCache Redis
#
# Allows the Checkout microservice running in Amazon EKS
# to connect to the Redis cluster over TCP/6379.
# ------------------------------------------------------------------------------
resource "aws_security_group" "checkout_redis_security_group" {

  name        = "checkout-redis-sg"
  description = "Security Group for the Checkout Redis ElastiCache instance"

  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    description = "Allow Redis from EKS Cluster"
    from_port   = 6379
    to_port     = 6379
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

      Name = "checkout-redis-sg"

    }

  )

}
