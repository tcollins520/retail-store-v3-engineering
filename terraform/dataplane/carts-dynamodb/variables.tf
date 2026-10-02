variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment_name" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "environment" {
  description = "Short environment name used in AWS resource names"
  type        = string
}

variable "business_division" {
  description = "Business division"
  type        = string
  default     = "retail-v3"
}

variable "tags" {
  description = "Common tags applied to all resources"

  type = map(string)

  default = {
    Terraform   = "true"
    Environment = "prod"
    Project     = "retail-store-v3"
  }
}