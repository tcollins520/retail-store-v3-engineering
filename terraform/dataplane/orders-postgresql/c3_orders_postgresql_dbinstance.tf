resource "aws_db_instance" "orders_postgresql" {

  identifier = "${var.environment}-orders-postgresql"

  engine = "postgres"

  engine_version = "17.9"

  instance_class = "db.t4g.micro"

  allocated_storage = 20

  max_allocated_storage = 100

  storage_type = "gp3"

  storage_encrypted = true

  db_name = "orders"

  username = "postgres"

  password = var.orders_db_password

  db_subnet_group_name = aws_db_subnet_group.orders_postgresql.name

  vpc_security_group_ids = [
    aws_security_group.orders_postgresql.id
  ]

  publicly_accessible = false

  multi_az = false

  backup_retention_period = 7

  deletion_protection = false

  auto_minor_version_upgrade = true

  apply_immediately = true

  skip_final_snapshot = true

  tags = merge(
    var.tags,
    {
      Name        = "${var.environment}-orders-postgresql"
      Application = "orders"
      Database    = "postgresql"
    }
  )

}
################################################################################
# Outputs
################################################################################
output "orders_master_secret_arn" {
  description = "Secrets Manager application credentials ARN for the Orders database"
  value       = aws_secretsmanager_secret.orders_db.arn
}

output "orders_rds_hostname" {
  description = "Amazon RDS PostgreSQL hostname"
  value       = aws_db_instance.orders_postgresql.address
}