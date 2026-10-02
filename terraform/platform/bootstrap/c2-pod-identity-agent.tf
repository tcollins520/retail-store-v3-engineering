# ------------------------------------------------------------------------------
# Lookup the default Amazon EKS Pod Identity Agent version
#
# This datasource returns the default AWS-recommended version compatible
# with the Kubernetes version running in the EKS cluster.
# ------------------------------------------------------------------------------

data "aws_eks_addon_version" "pod_identity_agent_default" {

  addon_name = "eks-pod-identity-agent"

  kubernetes_version = data.terraform_remote_state.eks.outputs.eks_cluster_version

}

# ------------------------------------------------------------------------------
# Lookup the latest Amazon EKS Pod Identity Agent version
#
# We install the most recent version supported by our EKS cluster.
# ------------------------------------------------------------------------------

data "aws_eks_addon_version" "pod_identity_agent_latest" {

  addon_name = "eks-pod-identity-agent"

  kubernetes_version = data.terraform_remote_state.eks.outputs.eks_cluster_version

  most_recent = true

}

# ------------------------------------------------------------------------------
# Install the Amazon EKS Pod Identity Agent
#
# The Pod Identity Agent runs as a DaemonSet on every worker node.
#
# It enables Kubernetes ServiceAccounts to securely assume IAM Roles
# without using long-lived AWS credentials inside Pods.
#
# This is the foundation for securely accessing AWS services such as:
#
# • Secrets Manager
# • Amazon S3
# • Amazon SQS
# • Amazon DynamoDB
# • Amazon RDS IAM Authentication
#
# Our Retail Store v2 platform will use Pod Identity to allow
# microservices to retrieve secrets securely from AWS Secrets Manager.
# ------------------------------------------------------------------------------

resource "aws_eks_addon" "pod_identity_agent" {

  cluster_name = data.terraform_remote_state.eks.outputs.eks_cluster_name

  addon_name = "eks-pod-identity-agent"

  addon_version = data.aws_eks_addon_version.pod_identity_agent_latest.version

  resolve_conflicts_on_create = "OVERWRITE"

  resolve_conflicts_on_update = "OVERWRITE"

  tags = var.tags

}

# ------------------------------------------------------------------------------
# Outputs
# ------------------------------------------------------------------------------

output "pod_identity_agent_default_version" {

  description = "Default Pod Identity Agent version supported by the EKS cluster"

  value = data.aws_eks_addon_version.pod_identity_agent_default.version

}

output "pod_identity_agent_latest_version" {

  description = "Latest Pod Identity Agent version compatible with the EKS cluster"

  value = data.aws_eks_addon_version.pod_identity_agent_latest.version

}

output "pod_identity_agent_arn" {

  description = "Amazon Resource Name (ARN) of the Pod Identity Agent add-on"

  value = aws_eks_addon.pod_identity_agent.arn

}

output "pod_identity_agent_id" {

  description = "ID of the Pod Identity Agent add-on"

  value = aws_eks_addon.pod_identity_agent.id

}