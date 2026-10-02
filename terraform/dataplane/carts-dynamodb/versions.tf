terraform {

  # Minimum Terraform CLI version required
  required_version = ">= 1.12.0"

  # Required providers
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }
  }

  # Remote backend configuration using S3
  backend "s3" {
    bucket       = "tfstate-prod-us-east-1-cg5idc"
    key          = "dataplane/carts-dynamodb/v3/prod/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }

}

provider "aws" {

  region = var.aws_region

}

provider "aws" {

  alias = "west2"

  region = "us-west-2"

}