# ------------------------------------------------------------------------------
# Create the Amazon RDS MySQL instance for the Catalog microservice
#
# This managed database stores all catalog product information.
#
# The instance uses:
# - Private subnets
# - Custom Security Group
# - Custom DB Parameter Group
# - gp3 storage
# - Encryption at rest
#
# The Catalog application will connect to this database using the
# endpoint exposed by Amazon RDS.
# ------------------------------------------------------------------------------
resource "aws_db_instance" "catalog_mysql" {

  # --------------------------------------------------------------------------
  # General Configuration
  # --------------------------------------------------------------------------

  identifier = "${var.environment_name}-catalog-mysql"

  engine         = "mysql"
  engine_version = "8.4"

  instance_class = "db.t4g.micro"

  # --------------------------------------------------------------------------
  # Storage Configuration
  # --------------------------------------------------------------------------

  allocated_storage = 20
  storage_type      = "gp3"

  # Encrypt the database storage using AWS-managed KMS keys
  storage_encrypted = true

  # --------------------------------------------------------------------------
  # Database Configuration
  # --------------------------------------------------------------------------

  db_name  = "catalog"
  username = local.catalog_db_username
  password = var.catalog_db_password

  # --------------------------------------------------------------------------
  # Networking
  # --------------------------------------------------------------------------

  # Deploy the database into the private subnets
  db_subnet_group_name = aws_db_subnet_group.catalog_mysql.name

  # Allow access only from Amazon EKS
  vpc_security_group_ids = [
    aws_security_group.catalog_mysql.id
  ]

  # Apply our custom MySQL parameter group
  parameter_group_name = aws_db_parameter_group.catalog_mysql.name

  # Never expose the database publicly
  publicly_accessible = false

  # --------------------------------------------------------------------------
  # Availability & Backups
  # --------------------------------------------------------------------------

  # Single AZ for the lab environment
  multi_az = false

  # Retain automated backups for seven days
  backup_retention_period = 7

  # Apply configuration changes immediately
  apply_immediately = true

  # Automatically install minor MySQL updates
  auto_minor_version_upgrade = true

  # --------------------------------------------------------------------------
  # Deletion Settings
  # --------------------------------------------------------------------------

  # Disabled for lab environments
  deletion_protection = false

  # Skip the final snapshot when destroying the database
  skip_final_snapshot = true

  # --------------------------------------------------------------------------
  # Resource Tags
  # --------------------------------------------------------------------------

  tags = merge(
    var.tags,
    {
      Name        = "${var.environment_name}-catalog-mysql"
      Application = "catalog"
      Database    = "mysql"
    }
  )
}

################################################################################
# Outputs
################################################################################

output "catalog_rds_endpoint" {
  description = "Amazon RDS MySQL endpoint for the Catalog microservice"
  value       = aws_db_instance.catalog_mysql.endpoint
}

output "catalog_rds_hostname" {
  value = aws_db_instance.catalog_mysql.address
}

output "catalog_rds_port" {
  description = "Amazon RDS MySQL port"
  value       = aws_db_instance.catalog_mysql.port
}

output "catalog_rds_database" {
  description = "Catalog database name"
  value       = aws_db_instance.catalog_mysql.db_name
}
