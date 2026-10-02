resource "aws_eks_pod_identity_association" "ebs_csi_driver" {

  cluster_name = data.terraform_remote_state.eks.outputs.eks_cluster_name

  namespace = "kube-system"

  service_account = "ebs-csi-controller-sa"

  role_arn = aws_iam_role.ebs_csi_driver.arn

}