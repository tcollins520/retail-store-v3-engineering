# RDS PostgreSQL Database Subnet Group for Orders Microservice
resource "aws_db_subnet_group" "orders_postgresql" {

  name = "orders-postgresql-db-subnet-group"

  description = "Subnet group for the Orders PostgreSQL Amazon RDS instance"

  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnet_ids

  tags = merge(
    var.tags,
    {
      Name = "orders-postgresql-db-subnet-group"
    }
  )
}