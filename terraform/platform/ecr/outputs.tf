# ==============================================================================
# ECR OUTPUTS
# ==============================================================================

output "repository_urls" {
  description = "URLs of the Retail Store v2 ECR repositories"

  value = {
    for name, repository in aws_ecr_repository.application :
    name => repository.repository_url
  }
}

output "repository_arns" {
  description = "ARNs of the Retail Store v2 ECR repositories"

  value = {
    for name, repository in aws_ecr_repository.application :
    name => repository.arn
  }
}
