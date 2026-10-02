# ------------------------------------------------------------------------------
# Retrieve the default Amazon EBS CSI Driver add-on version
# compatible with the current Kubernetes version.
# ------------------------------------------------------------------------------
data "aws_eks_addon_version" "ebs_csi_driver_default" {

  addon_name = "aws-ebs-csi-driver"

  kubernetes_version = data.terraform_remote_state.eks.outputs.eks_cluster_version
}

# ------------------------------------------------------------------------------
# Retrieve the latest Amazon EBS CSI Driver add-on version
# compatible with the current Kubernetes version.
# ------------------------------------------------------------------------------
data "aws_eks_addon_version" "ebs_csi_driver_latest" {

  addon_name = "aws-ebs-csi-driver"

  kubernetes_version = data.terraform_remote_state.eks.outputs.eks_cluster_version

  most_recent = true
}

# ------------------------------------------------------------------------------
# Install the Amazon EBS CSI Driver EKS Add-on
#
# This add-on enables Kubernetes to dynamically provision
# Amazon EBS volumes for PersistentVolumeClaims.
#
# The driver uses the IAM Role created earlier through
# Amazon EKS Pod Identity to securely communicate with
# the AWS EC2 API.
# ------------------------------------------------------------------------------
resource "aws_eks_addon" "ebs_csi_driver" {

  # Target EKS Cluster
  cluster_name = data.terraform_remote_state.eks.outputs.eks_cluster_name

  # AWS-managed EKS Add-on
  addon_name = "aws-ebs-csi-driver"

  # Install the latest supported version
  addon_version = data.aws_eks_addon_version.ebs_csi_driver_latest.version

  # IAM Role used by the controller through Pod Identity
  service_account_role_arn = aws_iam_role.ebs_csi_driver.arn

  # Preserve our desired configuration if AWS detects conflicts
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

}