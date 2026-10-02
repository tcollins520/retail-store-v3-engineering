############################################################
# GitHub OIDC Provider
############################################################

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  tags = var.tags
}

############################################################
# GitHub Actions Trust Policy
############################################################

data "aws_iam_policy_document" "github_assume_role" {

  statement {

    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {

      type = "Federated"

      identifiers = [
        aws_iam_openid_connect_provider.github.arn
      ]
    }

    condition {

      test = "StringEquals"

      variable = "token.actions.githubusercontent.com:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }

    condition {

      test = "StringLike"

      variable = "token.actions.githubusercontent.com:sub"

      values = [
        "repo:${var.github_repository}:ref:refs/heads/${var.github_branch}"
      ]
    }
  }
}

############################################################
# IAM Role
############################################################

resource "aws_iam_role" "github_actions" {

  name = "github-actions-oidc-role-retail-v3"

  assume_role_policy = data.aws_iam_policy_document.github_assume_role.json

  tags = var.tags
}

############################################################
# ECR Policy
############################################################

resource "aws_iam_policy" "github_actions_ecr" {

  name = "github-actions-ecr-retail-v3"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Action = [

          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:BatchGetImage",
          "ecr:DescribeRepositories",
          "ecr:DescribeImages",
          "ecr:ListImages"

        ]

        Resource = "*"

      }

    ]

  })

  tags = var.tags
}

############################################################
# Attach Policy
############################################################

resource "aws_iam_role_policy_attachment" "github_actions" {

  role = aws_iam_role.github_actions.name

  policy_arn = aws_iam_policy.github_actions_ecr.arn
}
