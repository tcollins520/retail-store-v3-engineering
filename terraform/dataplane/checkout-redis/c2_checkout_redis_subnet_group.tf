# ------------------------------------------------------------------------------
# ElastiCache Redis Subnet Group
# ------------------------------------------------------------------------------

resource "aws_elasticache_subnet_group" "checkout_redis_subnet_group" {

  name = "checkout-redis-subnet-group"

  description = "Subnet group for the Checkout Redis ElastiCache cluster"

  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnet_ids

  tags = merge(
    var.tags,
    {
      Name        = "checkout-redis-subnet-group"
      Application = "checkout"
    }
  )

}