# ------------------------------------------------------------------------------
# Install the AWS Load Balancer Controller using Helm
#
# The AWS Load Balancer Controller manages:
#
# • Application Load Balancers (ALB)
# • Network Load Balancers (NLB)
# • Target Groups
# • Listener Rules
#
# It watches Kubernetes Ingress and Service resources and automatically
# provisions AWS Load Balancers.
#
# Authentication to AWS is provided through Amazon EKS Pod Identity.
# ------------------------------------------------------------------------------

resource "helm_release" "loadbalancer_controller" {

  depends_on = [
    aws_iam_role.lbc_iam_role,
    aws_eks_pod_identity_association.lbc,
    aws_eks_addon.pod_identity_agent
  ]

  name = "aws-load-balancer-controller"

  repository = "https://aws.github.io/eks-charts"

  chart = "aws-load-balancer-controller"

  namespace = "kube-system"

  # Wait until all controller Pods become Ready
  wait = true

  timeout = 600

  cleanup_on_fail = true

  ##########################################################################
  # Helm Values
  ##########################################################################

  set = [
    {
      name  = "serviceAccount.create"
      value = "true"
    },
    {
      name  = "serviceAccount.name"
      value = "aws-load-balancer-controller"
    },
    {
      name  = "clusterName"
      value = data.terraform_remote_state.eks.outputs.eks_cluster_name
    },
    {
      name  = "region"
      value = var.aws_region
    },
    {
      name  = "vpcId"
      value = data.terraform_remote_state.vpc.outputs.vpc_id
    }
  ]

}

# ------------------------------------------------------------------------------
# Outputs
# ------------------------------------------------------------------------------

output "helm_lbc_metadata" {

  description = "Metadata for the AWS Load Balancer Controller Helm release"

  value = helm_release.loadbalancer_controller.metadata

}