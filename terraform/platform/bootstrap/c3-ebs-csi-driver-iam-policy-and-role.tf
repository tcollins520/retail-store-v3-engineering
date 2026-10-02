# ------------------------------------------------------------------------------
# Generate the IAM Trust Policy for the Amazon EBS CSI Driver
#
# This policy defines WHO is allowed to assume the IAM Role.
#
# In this case, the Amazon EKS Pod Identity Agent allows Kubernetes pods
# (pods.eks.amazonaws.com) to assume this IAM Role on behalf of the
# EBS CSI Controller running inside the cluster.
#
# Terraform generates the JSON automatically, eliminating the need to
# maintain a separate trust-policy.json file.
# ------------------------------------------------------------------------------
data "aws_iam_policy_document" "ebs_csi_assume_role" {

  statement {

    # Allow the trusted principal to assume this IAM Role
    effect = "Allow"

    # Required STS actions for AWS Pod Identity
    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]

    # The trusted principal is any Kubernetes pod using
    # Amazon EKS Pod Identity
    principals {
      type = "Service"

      identifiers = [
        "pods.eks.amazonaws.com"
      ]
    }

  }

}

# ------------------------------------------------------------------------------
# Create the IAM Role for the Amazon EBS CSI Driver
#
# This IAM Role will later be associated with the Kubernetes
# ServiceAccount (ebs-csi-controller-sa) using an
# EKS Pod Identity Association.
#
# The role name includes the EKS cluster name retrieved from
# Terraform Remote State to avoid hardcoding cluster-specific values.
# ------------------------------------------------------------------------------
#################################################
# IAM Role
#################################################
resource "aws_iam_role" "ebs_csi_driver" {

  # Create a unique role name using the EKS cluster name
  name = "${data.terraform_remote_state.eks.outputs.eks_cluster_name}-ebs-csi-driver"

  # Attach the generated trust policy to this IAM Role
  assume_role_policy = data.aws_iam_policy_document.ebs_csi_assume_role.json
}

# ------------------------------------------------------------------------------
# Attach the AWS Managed AmazonEBSCSIDriverPolicy
#
# This managed policy grants the EBS CSI Driver permission to:
#   • Create Amazon EBS volumes
#   • Attach volumes to EC2 instances
#   • Detach volumes
#   • Delete volumes
#   • Create snapshots
#
# Without this policy, Kubernetes would be unable to dynamically
# provision Persistent Volumes from Amazon EBS.
# ------------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "ebs_csi_driver_policy" {

  # IAM Role that receives the permissions
  role = aws_iam_role.ebs_csi_driver.name

  # AWS-managed policy for the EBS CSI Driver
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"

}