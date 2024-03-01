data "aws_partition" "current" {}

resource "aws_iam_openid_connect_provider" "oidc_provider" {
  client_id_list  = ["sts.${data.aws_partition.current.dns_suffix}"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"]
  url             = aws_eks_cluster.this.identity[0].oidc[0].issuer
  #url             = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer

  #   tags = merge({
  #     Name = "${local.eks_cluster_name}-eks-irsa"
  #   }, local.common_tags)
}



