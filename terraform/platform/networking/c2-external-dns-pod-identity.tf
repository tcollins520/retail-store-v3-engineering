
# ------------------------------------------------------------------------------
# Create the Kubernetes Service Account for ExternalDNS
#
# ExternalDNS will authenticate to AWS using Amazon EKS Pod Identity.
# ------------------------------------------------------------------------------

resource "kubernetes_service_account_v1" "externaldns" {

  metadata {

    name      = "external-dns"
    namespace = "kube-system"

    labels = {

      "app.kubernetes.io/name"    = "external-dns"
      "app.kubernetes.io/part-of" = "retail-store-v3"

    }

  }

}

# ------------------------------------------------------------------------------
# Associate the Service Account with the IAM Role
#
# Amazon EKS Pod Identity automatically injects temporary AWS credentials
# into ExternalDNS pods.
# ------------------------------------------------------------------------------

resource "aws_eks_pod_identity_association" "externaldns" {

  cluster_name = data.terraform_remote_state.eks.outputs.eks_cluster_name

  namespace = "kube-system"

  service_account = kubernetes_service_account_v1.externaldns.metadata[0].name
  role_arn        = aws_iam_role.externaldns_role.arn

}

# ------------------------------------------------------------------------------
# Outputs
# ------------------------------------------------------------------------------

output "externaldns_service_account" {

  description = "Kubernetes ServiceAccount used by ExternalDNS"

  value = kubernetes_service_account_v1.externaldns.metadata[0].name

}

output "externaldns_pod_identity_association_id" {

  description = "Amazon EKS Pod Identity Association ID"

  value = aws_eks_pod_identity_association.externaldns.association_id

}
