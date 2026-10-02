# ------------------------------------------------------------------------------
# Generate the IAM Trust Policy for the Cart microservice
#
# This trust policy allows Amazon EKS Pod Identity to assume the IAM Role
# on behalf of the Cart microservice running inside Kubernetes.
# ------------------------------------------------------------------------------

data "aws_iam_policy_document" "cart_assume_role" {

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
# Create the IAM Policy for the Cart microservice
#
# Grants the Cart microservice permission to access the DynamoDB Items table
# and its Global Secondary Indexes.
# ------------------------------------------------------------------------------

resource "aws_iam_policy" "cart_dynamodb_policy" {

  name        = "${var.environment}-cart-dynamodb-policy"
  description = "Allow the Cart microservice to access the DynamoDB Items table"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Action = [

          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:BatchGetItem",
          "dynamodb:BatchWriteItem",
          "dynamodb:DescribeTable"

        ]

        Resource = [

          aws_dynamodb_table.items_west2.arn,
          "${aws_dynamodb_table.items_west2.arn}/index/*"

        ]

      }

    ]

  })

  tags = merge(

    var.tags,

    {

      Name        = "${var.environment}-cart-dynamodb-policy"
      Application = "carts"

    }

  )

}

# ------------------------------------------------------------------------------
# Create the IAM Role for the Cart microservice
#
# This IAM Role is associated with the Cart Kubernetes ServiceAccount
# using Amazon EKS Pod Identity.
#
# The attached IAM Policy allows the Cart microservice to access
# the DynamoDB Items table.
# ------------------------------------------------------------------------------

resource "aws_iam_role" "cart_pod_identity_role" {

  name = "${var.environment}-cart-pod-identity-role"

  assume_role_policy = data.aws_iam_policy_document.cart_assume_role.json

  tags = merge(

    var.tags,

    {

      Name        = "${var.environment}-cart-pod-identity-role"
      Application = "carts"

    }

  )

}

# ------------------------------------------------------------------------------
# Attach the DynamoDB IAM Policy to the Cart IAM Role
# ------------------------------------------------------------------------------

resource "aws_iam_role_policy_attachment" "cart_dynamodb_policy_attachment" {

  role       = aws_iam_role.cart_pod_identity_role.name
  policy_arn = aws_iam_policy.cart_dynamodb_policy.arn

}

# ------------------------------------------------------------------------------
# Outputs
# ------------------------------------------------------------------------------

output "cart_dynamodb_policy_arn" {

  description = "IAM Policy ARN granting access to the DynamoDB Items table"

  value = aws_iam_policy.cart_dynamodb_policy.arn

}

output "cart_pod_identity_role_arn" {

  description = "IAM Role ARN used by the Cart microservice"

  value = aws_iam_role.cart_pod_identity_role.arn

}