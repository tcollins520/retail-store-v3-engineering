# ------------------------------------------------------------------------------
# Download the official AWS Load Balancer Controller IAM Policy
#
# The policy is maintained by the Kubernetes SIG AWS project and contains
# the AWS permissions required for the AWS Load Balancer Controller to manage:
#
# • Application Load Balancers (ALBs)
# • Network Load Balancers (NLBs)
# • Target Groups
# • Listeners
# • Security Groups
# • Target Registration
#
# Terraform downloads the latest policy document from the official project
# repository and uses it to create an AWS IAM Policy.
# ------------------------------------------------------------------------------
data "http" "lbc_iam_policy" {

  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json"

  request_headers = {
    Accept = "application/json"
  }

}