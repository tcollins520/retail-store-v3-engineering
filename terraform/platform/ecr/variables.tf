# -----------------------------------------------------------------------------
# AWS REGION
# -----------------------------------------------------------------------------
variable "aws_region" {
  description = "AWS region where ECR repositories will be created"
  type        = string
  default     = "us-east-1"
}

# -----------------------------------------------------------------------------
# ENVIRONMENT AND BUSINESS DIVISION
# -----------------------------------------------------------------------------
variable "environment_name" {
  description = "Environment name used in tags"
  type        = string
  default     = "prod"
}

variable "business_division" {
  description = "Business division that owns the platform"
  type        = string
  default     = "retail-v2"
}

# -----------------------------------------------------------------------------
# ECR REPOSITORIES
# -----------------------------------------------------------------------------
variable "repository_names" {
  description = "Names of the ECR repositories for Retail Store v2 services"
  type        = set(string)

  default = [
    "retail-store-v3/catalog",
    "retail-store-v3/carts",
    "retail-store-v3/checkout",
    "retail-store-v3/orders",
    "retail-store-v3/ui"
  ]
}

variable "image_tag_mutability" {
  description = "Whether image tags are mutable or immutable"
  type        = string
  default     = "IMMUTABLE"

  validation {
    condition = contains(
      ["MUTABLE", "IMMUTABLE"],
      var.image_tag_mutability
    )

    error_message = "image_tag_mutability must be MUTABLE or IMMUTABLE."
  }
}

variable "max_image_count" {
  description = "Maximum number of tagged images retained per repository"
  type        = number
  default     = 10
}

# -----------------------------------------------------------------------------
# COMMON TAGS
# -----------------------------------------------------------------------------
variable "tags" {
  description = "Common tags applied to all ECR resources"
  type        = map(string)

  default = {
    Terraform = "true"
  }
}
