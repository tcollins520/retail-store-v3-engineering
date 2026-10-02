# ------------------------------------------------------------------------------
# Install the Secrets Store CSI Driver
#
# The Secrets Store CSI Driver enables Kubernetes Pods to mount secrets
# directly from external secret providers.
#
# In Retail Store v2, the driver will retrieve secrets from
# AWS Secrets Manager through the AWS Secrets and Configuration Provider (ASCP).
#
# Authentication is provided through Amazon EKS Pod Identity.
# ------------------------------------------------------------------------------
resource "helm_release" "secrets_store_csi_driver" {
  depends_on = [
    aws_eks_addon.pod_identity_agent,
    helm_release.loadbalancer_controller
  ]

  name       = "csi-secrets-store"
  repository = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
  chart      = "secrets-store-csi-driver"
  namespace  = "kube-system"


  set = [
    {
      name  = "syncSecret.enabled"
      value = "true"
    },
    {
      name  = "tokenRequests[0].audience"
      value = "pods.eks.amazonaws.com"
    }
  ]
  # Wait until all pods are ready
  wait            = true
  timeout         = 600
  cleanup_on_fail = true
}

# Outputs

output "helm_secrets_store_csi_driver_metadata" {
  description = "Metadata for the Secrets Store CSI Driver Helm release"
  value       = helm_release.secrets_store_csi_driver.metadata
}
