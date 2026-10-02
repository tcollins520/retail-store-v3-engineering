data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "tfstate-prod-us-east-1-cg5idc"
    key    = "vpc/v3/prod/terraform.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "eks" {
  backend = "s3"

  config = {
    bucket = "tfstate-prod-us-east-1-cg5idc"
    key    = "eks/v3/prod/terraform.tfstate"
    region = var.aws_region
  }
}