# ------------------------------------------------------------------------------
# Generate the IAM Trust Policy for the Catalog microservice
#
# This trust policy allows Amazon EKS Pod Identity to assume the IAM Role
# on behalf of the Catalog microservice running inside Kubernetes.
# ------------------------------------------------------------------------------

data "aws_iam_policy_document" "catalog_assume_role" {

  statement {

    effect = "Allow"

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]

    principals {

      type = "Service"

      identifiers = [
        "pods.eks.amazonaws.com"
      ]

    }

  }

}

# ------------------------------------------------------------------------------
# Create the IAM Role for the Catalog microservice
#
# This IAM Role will be associated with the Catalog Kubernetes ServiceAccount
# using Amazon EKS Pod Identity.
#
# The role grants access to:
# • AWS Secrets Manager (RDS credentials)
# ------------------------------------------------------------------------------

resource "aws_iam_role" "catalog_pod_identity_role" {

  name = "${var.environment}-catalog-pod-identity-role"

  assume_role_policy = data.aws_iam_policy_document.catalog_assume_role.json

  tags = merge(
    var.tags,
    {
      Name        = "${var.environment}-catalog-pod-identity-role"
      Application = "catalog"
    }
  )

}

# ------------------------------------------------------------------------------
# Attach the Secrets Manager IAM Policy
#
# The policy grants permission for the Catalog microservice to retrieve
# its MySQL credentials from AWS Secrets Manager.
# ------------------------------------------------------------------------------

resource "aws_iam_role_policy_attachment" "catalog_secret_policy_attachment" {

  role = aws_iam_role.catalog_pod_identity_role.name

  policy_arn = aws_iam_policy.catalog_secretsmanager_policy.arn

}

# ------------------------------------------------------------------------------
# Outputs
# ------------------------------------------------------------------------------

output "catalog_pod_identity_role_arn" {

  description = "IAM Role ARN used by the Catalog microservice"

  value = aws_iam_role.catalog_pod_identity_role.arn

}