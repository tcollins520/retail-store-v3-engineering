
# ------------------------------------------------------------------------------
# Remote State - EKS
# ------------------------------------------------------------------------------

data "terraform_remote_state" "eks" {

  backend = "s3"

  config = {
    bucket = "tfstate-prod-us-east-1-cg5idc"
    key    = "eks/v3/prod/terraform.tfstate"
    region = "us-east-1"
  }

}

# ------------------------------------------------------------------------------
# Remote State - VPC
# ------------------------------------------------------------------------------

data "terraform_remote_state" "vpc" {

  backend = "s3"

  config = {
    bucket = "tfstate-prod-us-east-1-cg5idc"
    key    = "vpc/v3/prod/terraform.tfstate"
    region = "us-east-1"
  }

}

# ------------------------------------------------------------------------------
# EKS Authentication
# ------------------------------------------------------------------------------

data "aws_eks_cluster_auth" "eks" {

  name = data.terraform_remote_state.eks.outputs.eks_cluster_name

}
