variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "github_repository" {
  description = "GitHub repository allowed to assume this role"
  type        = string
  default     = "tcollins520/retail-store-v3-engineering"
}

variable "github_branch" {
  description = "GitHub branch allowed to assume this role"
  type        = string
  default     = "main"
}

variable "tags" {
  description = "Common tags"

  type = map(string)

  default = {
    Terraform   = "true"
    Project     = "retail-store-v3"
    Environment = "production"
  }
}