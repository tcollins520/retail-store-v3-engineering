
# ------------------------------------------------------------------------------
# Generate the IAM Trust Policy for ExternalDNS
#
# This trust policy allows Amazon EKS Pod Identity to assume the IAM Role
# on behalf of the ExternalDNS controller running inside Kubernetes.
# ------------------------------------------------------------------------------

data "aws_iam_policy_document" "externaldns_assume_role" {

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
# Create the IAM Policy for ExternalDNS
#
# Grants ExternalDNS permission to:
# - Discover hosted zones
# - Read Route53 records
# - Create, update, and delete DNS records
# ------------------------------------------------------------------------------

resource "aws_iam_policy" "externaldns_policy" {

  name = "${var.business_division}-${var.environment_name}-externaldns-policy"

  description = "Allow ExternalDNS to manage Route53 DNS records"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Action = [
          "route53:ChangeResourceRecordSets"
        ]

        Resource = [
          "arn:aws:route53:::hostedzone/*"
        ]

      },

      {

        Effect = "Allow"

        Action = [
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets",
          "route53:ListTagsForResource",
          "route53:GetHostedZone"
        ]

        Resource = "*"

      }

    ]

  })

  tags = merge(

    var.tags,

    {

      Name        = "${var.business_division}-${var.environment_name}-externaldns-policy"
      Application = "externaldns"

    }

  )

}

# ------------------------------------------------------------------------------
# Create the IAM Role for ExternalDNS
# ------------------------------------------------------------------------------

resource "aws_iam_role" "externaldns_role" {

  name = "${var.business_division}-${var.environment_name}-externaldns-role"

  assume_role_policy = data.aws_iam_policy_document.externaldns_assume_role.json

  tags = merge(

    var.tags,

    {

      Name        = "${var.business_division}-${var.environment_name}-externaldns-role"
      Application = "externaldns"

    }

  )

}

# ------------------------------------------------------------------------------
# Attach the IAM Policy to the IAM Role
# ------------------------------------------------------------------------------

resource "aws_iam_role_policy_attachment" "externaldns_policy_attachment" {

  role = aws_iam_role.externaldns_role.name

  policy_arn = aws_iam_policy.externaldns_policy.arn

}

# ------------------------------------------------------------------------------
# Outputs
# ------------------------------------------------------------------------------

output "externaldns_role_arn" {

  description = "IAM Role ARN used by ExternalDNS"

  value = aws_iam_role.externaldns_role.arn

}

output "externaldns_policy_arn" {

  description = "IAM Policy ARN used by ExternalDNS"

  value = aws_iam_policy.externaldns_policy.arn

}
