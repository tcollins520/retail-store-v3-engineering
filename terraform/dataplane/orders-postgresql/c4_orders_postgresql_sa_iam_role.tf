# ------------------------------------------------------------------------------
# Generate the IAM Trust Policy for the Orders microservice
#
# This trust policy allows Amazon EKS Pod Identity to assume the IAM Role
# on behalf of the Orders microservice running inside Kubernetes.
# ------------------------------------------------------------------------------

data "aws_iam_policy_document" "orders_assume_role" {

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
# Create the IAM Role for the Orders microservice
#
# This IAM Role will be associated with the Orders Kubernetes ServiceAccount
# using Amazon EKS Pod Identity.
#
# The role grants access to:
# • AWS Secrets Manager (RDS credentials)
# • Amazon SQS (attached in c9_07)
# ------------------------------------------------------------------------------

resource "aws_iam_role" "orders_pod_identity_role" {

  name = "${var.environment}-orders-pod-identity-role"

  assume_role_policy = data.aws_iam_policy_document.orders_assume_role.json

  tags = merge(
    var.tags,
    {
      Name        = "${var.environment}-orders-pod-identity-role"
      Application = "orders"
    }
  )

}

# ------------------------------------------------------------------------------
# Attach the Secrets Manager IAM Policy
#
# The policy grants permission for the Orders microservice to retrieve
# its PostgreSQL credentials from AWS Secrets Manager.
# ------------------------------------------------------------------------------

resource "aws_iam_role_policy_attachment" "orders_secret_policy_attachment" {

  role = aws_iam_role.orders_pod_identity_role.name

  policy_arn = aws_iam_policy.orders_secretsmanager_policy.arn

}

# ------------------------------------------------------------------------------
# Outputs
# ------------------------------------------------------------------------------

output "orders_pod_identity_role_arn" {

  description = "IAM Role ARN used by the Orders microservice"

  value = aws_iam_role.orders_pod_identity_role.arn

}