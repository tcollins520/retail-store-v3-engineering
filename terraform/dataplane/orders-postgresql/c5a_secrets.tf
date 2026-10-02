# ------------------------------------------------------------------------------
# Local Values
# ------------------------------------------------------------------------------

locals {

  orders_db_username = "postgres"

}

# ------------------------------------------------------------------------------
# Secrets Manager Secret
# ------------------------------------------------------------------------------

resource "aws_secretsmanager_secret" "orders_db" {

  name        = "${var.environment_name}/orders/database"
  description = "Orders database credentials"

  tags = merge(
    var.tags,
    {
      Name        = "${var.environment_name}-orders-db-secret"
      Environment = var.environment_name
      Application = "orders"
    }
  )

}

# ------------------------------------------------------------------------------
# Secret Value
# ------------------------------------------------------------------------------

resource "aws_secretsmanager_secret_version" "orders_db" {

  secret_id = aws_secretsmanager_secret.orders_db.id

  secret_string = jsonencode({
    username = local.orders_db_username
    password = var.orders_db_password
  })

}

# ------------------------------------------------------------------------------
# Outputs
# ------------------------------------------------------------------------------

output "orders_secret_arn" {

  description = "Secrets Manager ARN for the Orders database"

  value = aws_secretsmanager_secret.orders_db.arn

}