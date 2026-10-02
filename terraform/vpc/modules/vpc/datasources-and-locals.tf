# Datasources
data "aws_availability_zones" "available" {
  state = "available"
}

# Locals Block using slice function to limit the number of availability zones to 3 and generate public and private subnets based on the VPC CIDR and subnet_newbits variable
locals {
  azs             = slice(data.aws_availability_zones.available.names, 0, 3)
  public_subnets  = [for k, az in local.azs : cidrsubnet(var.vpc_cidr, var.subnet_newbits, k)]
  private_subnets = [for k, az in local.azs : cidrsubnet(var.vpc_cidr, var.subnet_newbits, k + 10)]
}
