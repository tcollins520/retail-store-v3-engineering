# ------------------------------------------------------------------------------
# Create a custom DB Parameter Group for the Catalog MySQL Amazon RDS instance
#
# A DB Parameter Group is similar to the MySQL configuration file (my.cnf).
# It allows us to customize database engine settings such as:
# - max_connections
# - slow query logging
# - character set
# - time zone
#
# For now, we are using the default MySQL parameters by creating an empty
# custom parameter group. This gives us the flexibility to customize
# settings later without replacing the database instance.
# ------------------------------------------------------------------------------
resource "aws_db_parameter_group" "catalog_mysql" {

  name = "catalog-mysql-parameter-group"

  description = "Parameter group for the Catalog MySQL Amazon RDS instance"

  family = "mysql8.4"

  tags = merge(
    var.tags,
    {
      Name = "catalog-mysql-parameter-group"
    }
  )
}