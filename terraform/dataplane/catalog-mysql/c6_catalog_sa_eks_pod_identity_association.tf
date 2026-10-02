# ------------------------------------------------------------------------------
# EKS Pod Identity Association
#
# Associates the Catalog Kubernetes ServiceAccount with the IAM Role
# that grants access to AWS Secrets Manager.
# ------------------------------------------------------------------------------

resource "aws_eks_pod_identity_association" "catalog" {

  cluster_name = data.terraform_remote_state.eks.outputs.eks_cluster_name

  namespace = "default"

  service_account = "catalog"

  role_arn = aws_iam_role.catalog_pod_identity_role.arn

}

# ------------------------------------------------------------------------------
# Outputs
# ------------------------------------------------------------------------------

output "catalog_pod_identity_association_arn" {

  description = "Pod Identity Association ARN for the Catalog ServiceAccount"

  value = aws_eks_pod_identity_association.catalog.association_arn

}