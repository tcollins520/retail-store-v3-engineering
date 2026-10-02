variable "environment_name" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
  default     = "prod"
}

variable "aws_region" {
  description = "AWS region to deploy backend (e.g., us-east-1, us-west-2)"
  type        = string
  default     = "us-east-1"
}
