# ------------------------------------------------------------------------------
# Local Values
# ------------------------------------------------------------------------------

locals {

  catalog_db_username = "admin"

}

# ------------------------------------------------------------------------------
# Secrets Manager Secret
# ------------------------------------------------------------------------------

resource "aws_secretsmanager_secret" "catalog_db" {

  name        = "${var.environment_name}/catalog/database"
  description = "Catalog database credentials"

  tags = merge(
    var.tags,
    {
      Name        = "${var.environment_name}-catalog-db-secret"
      Environment = var.environment_name
      Application = "catalog"
    }
  )

}

# ------------------------------------------------------------------------------
# Secret Value
# ------------------------------------------------------------------------------

resource "aws_secretsmanager_secret_version" "catalog_db" {

  secret_id = aws_secretsmanager_secret.catalog_db.id

  secret_string = jsonencode({
    username = local.catalog_db_username
    password = var.catalog_db_password
  })

}

# ------------------------------------------------------------------------------
# Outputs
# ------------------------------------------------------------------------------

output "catalog_secret_arn" {

  description = "Secrets Manager ARN for the Catalog database"

  value = aws_secretsmanager_secret.catalog_db.arn

}