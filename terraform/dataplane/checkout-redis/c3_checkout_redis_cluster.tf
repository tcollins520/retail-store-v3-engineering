# ------------------------------------------------------------------------------
# Amazon ElastiCache Redis Cluster
# ------------------------------------------------------------------------------

resource "aws_elasticache_cluster" "checkout_redis" {

  cluster_id = "${var.environment}-checkout-redis"

  engine = "redis"

  engine_version = "7.1"

  node_type = "cache.t3.micro"

  num_cache_nodes = 1

  port = 6379

  subnet_group_name = aws_elasticache_subnet_group.checkout_redis_subnet_group.name

  security_group_ids = [
    aws_security_group.checkout_redis_security_group.id
  ]

  parameter_group_name = "default.redis7"

  tags = merge(
    var.tags,
    {
      Name        = "${var.environment}-checkout-redis"
      Application = "checkout"
    }
  )

}

# ------------------------------------------------------------------------------
# Outputs
# ------------------------------------------------------------------------------

output "checkout_redis_endpoint" {

  description = "Redis endpoint used by the Checkout microservice"

  value = aws_elasticache_cluster.checkout_redis.cache_nodes[0].address

}

output "checkout_redis_port" {

  description = "Redis port"

  value = aws_elasticache_cluster.checkout_redis.port

}