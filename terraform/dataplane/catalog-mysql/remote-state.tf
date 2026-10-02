# ------------------------------------------------------------------------------
# Reference the VPC Terraform Remote State
#
# Used to retrieve:
# - VPC ID
# - Private Subnet IDs
# ------------------------------------------------------------------------------

data "terraform_remote_state" "vpc" {

  backend = "s3"

  config = {
    bucket = "tfstate-prod-us-east-1-cg5idc"
    key    = "vpc/v3/prod/terraform.tfstate"
    region = var.aws_region
  }

}

# ------------------------------------------------------------------------------
# Reference the Amazon EKS Terraform Remote State
#
# Used to retrieve:
# - Cluster Name
# - Security Groups
# - Other EKS outputs
# ------------------------------------------------------------------------------

data "terraform_remote_state" "eks" {

  backend = "s3"

  config = {
    bucket = "tfstate-prod-us-east-1-cg5idc"
    key    = "eks/v3/prod/terraform.tfstate"
    region = var.aws_region
  }

}