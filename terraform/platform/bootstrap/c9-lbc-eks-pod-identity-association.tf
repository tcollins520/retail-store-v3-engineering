# ------------------------------------------------------------------------------
# Associate the AWS Load Balancer Controller ServiceAccount
# with its IAM Role using Amazon EKS Pod Identity.
# ------------------------------------------------------------------------------

resource "aws_eks_pod_identity_association" "lbc" {

  cluster_name = data.terraform_remote_state.eks.outputs.eks_cluster_name

  namespace = "kube-system"

  service_account = "aws-load-balancer-controller"

  role_arn = aws_iam_role.lbc_iam_role.arn

}

# ------------------------------------------------------------------------------
# Outputs
# ------------------------------------------------------------------------------

output "lbc_pod_identity_association_arn" {

  description = "AWS Load Balancer Controller Pod Identity Association ARN"

  value = aws_eks_pod_identity_association.lbc.association_arn

}