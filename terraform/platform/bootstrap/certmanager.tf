data "aws_eks_addon_version" "cert_manager_latest" {
  addon_name         = "cert-manager"
  kubernetes_version = data.terraform_remote_state.eks.outputs.eks_cluster_version
  most_recent        = true
}

resource "aws_eks_addon" "cert_manager" {
  cluster_name  = data.terraform_remote_state.eks.outputs.eks_cluster_id
  addon_name    = "cert-manager"
  addon_version = data.aws_eks_addon_version.cert_manager_latest.version

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  tags = var.tags
}