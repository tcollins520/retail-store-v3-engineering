# ------------------------------------------------------------------------------
# Generate the IAM Trust Policy for the AWS Load Balancer Controller
#
# This trust policy allows Amazon EKS Pod Identity to assume the IAM Role
# on behalf of the AWS Load Balancer Controller running inside Kubernetes.
# ------------------------------------------------------------------------------

data "aws_iam_policy_document" "lbc_assume_role" {

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
# Create the IAM Role for the AWS Load Balancer Controller
# ------------------------------------------------------------------------------

resource "aws_iam_role" "lbc_iam_role" {

  name = "${data.terraform_remote_state.eks.outputs.eks_cluster_name}-aws-load-balancer-controller"

  assume_role_policy = data.aws_iam_policy_document.lbc_assume_role.json

  tags = var.tags

}

# ------------------------------------------------------------------------------
# Create the IAM Policy
#
# The policy document is downloaded from the official AWS repository
# (see c7-lbc-iam-policy-datasources.tf).
# ------------------------------------------------------------------------------

resource "aws_iam_policy" "lbc_iam_policy" {

  name = "${data.terraform_remote_state.eks.outputs.eks_cluster_name}-aws-load-balancer-controller"

  description = "IAM Policy for the AWS Load Balancer Controller"

  policy = data.http.lbc_iam_policy.response_body

  tags = var.tags

}

# ------------------------------------------------------------------------------
# Attach the IAM Policy to the IAM Role
# ------------------------------------------------------------------------------

resource "aws_iam_role_policy_attachment" "lbc_iam_policy" {

  role = aws_iam_role.lbc_iam_role.name

  policy_arn = aws_iam_policy.lbc_iam_policy.arn

}

# ------------------------------------------------------------------------------
# Outputs
# ------------------------------------------------------------------------------

output "lbc_iam_role_arn" {

  description = "IAM Role ARN for the AWS Load Balancer Controller"

  value = aws_iam_role.lbc_iam_role.arn

}

output "lbc_iam_policy_arn" {

  description = "IAM Policy ARN for the AWS Load Balancer Controller"

  value = aws_iam_policy.lbc_iam_policy.arn

}