# ------------------------------------------------------------------------------------------------------------------------------------------
# Reference the Remote State from VPC Project
# EKS Cluster will get the VPC ID and Subnet IDs from the remote state of the VPC project to create the cluster in the same VPC and subnets.
# ------------------------------------------------------------------------------------------------------------------------------------------
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "tfstate-prod-us-east-1-cg5idc" # Name of the remote S3 bucket where the VPC state is stored
    key    = "vpc/v3/prod/terraform.tfstate" # Path to the VPC tfstate file within the bucket
    region = var.aws_region                  # Region where the S3 bucket exist
  }
}

# --------------------------------------------------------------------
# Output the VPC ID from the remote VPC state
# --------------------------------------------------------------------
output "vpc_id" {
  value = data.terraform_remote_state.vpc.outputs.vpc_id
}

# --------------------------------------------------------------------
# Output the list of private subnets from the VPC
# --------------------------------------------------------------------
output "private_subnet_ids" {
  value = data.terraform_remote_state.vpc.outputs.private_subnet_ids
}


# --------------------------------------------------------------------
# Output the list of public subnets from the VPC
# --------------------------------------------------------------------
output "public_subnet_ids" {
  value = data.terraform_remote_state.vpc.outputs.public_subnet_ids
}


