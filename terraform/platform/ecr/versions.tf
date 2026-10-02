terraform {
  # Minimum Terraform CLI version required
  required_version = ">= 1.12.0"

  # Required providers and version constraints
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }
  }

  # Remote backend configuration using S3
  backend "s3" {
    bucket       = "tfstate-prod-us-east-1-cg5idc"
    key          = "platform/ecr/v3/prod/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = merge(
      var.tags,
      {
        Environment      = var.environment_name
        BusinessDivision = var.business_division
        Project          = "retail-store-v3"
        ManagedBy        = "Terraform"
      }
    )
  }
}
