resource "aws_db_subnet_group" "catalog_mysql" {

  name = "catalog-mysql-db-subnet-group"

  description = "Subnet group for the Catalog MySQL Amazon RDS instance"

  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnet_ids

  tags = merge(
    var.tags,
    {
      Name = "catalog-mysql-db-subnet-group"
    }
  )
}