# ==============================================================================
# AMAZON ELASTIC CONTAINER REGISTRY
# Retail Store v2 Application Repositories
# ==============================================================================

resource "aws_ecr_repository" "application" {
  for_each = var.repository_names

  name                 = each.value
  image_tag_mutability = var.image_tag_mutability

  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = true
  }
}

# ------------------------------------------------------------------------------
# ECR LIFECYCLE POLICY
# Retain the newest application images and clean up stale untagged images
# ------------------------------------------------------------------------------

resource "aws_ecr_lifecycle_policy" "application" {
  for_each = aws_ecr_repository.application

  repository = each.value.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1

        description = "Remove untagged images older than 7 days"

        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 7
        }

        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2

        description = "Retain the latest ${var.max_image_count} images"

        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = var.max_image_count
        }

        action = {
          type = "expire"
        }
      }
    ]
  })
}
