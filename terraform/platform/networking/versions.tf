terraform {
  # Minimum Terraform CLI version required
  required_version = ">= 1.12.0"

  # Required providers and version constraints
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0"
    }
  }

  # Remote backend configuration using S3 
  backend "s3" {
    bucket       = "tfstate-prod-us-east-1-cg5idc"
    key          = "platform/networking/prod/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {

  region = var.aws_region

}

provider "kubernetes" {

  host = data.terraform_remote_state.eks.outputs.eks_cluster_endpoint

  cluster_ca_certificate = base64decode(
    data.terraform_remote_state.eks.outputs.eks_cluster_certificate_authority_data
  )

  token = data.aws_eks_cluster_auth.eks.token

}

provider "helm" {

  kubernetes = {

    host = data.terraform_remote_state.eks.outputs.eks_cluster_endpoint

    cluster_ca_certificate = base64decode(
      data.terraform_remote_state.eks.outputs.eks_cluster_certificate_authority_data
    )

    token = data.aws_eks_cluster_auth.eks.token

  }

}
