output "eks_cluster_id" {
  value = aws_eks_cluster.this.id
}

output "eks_cluster_certificate_authority" {
  value = aws_eks_cluster.this.certificate_authority
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "eks_cluster_identity" {
  value = aws_eks_cluster.this.identity
}

output "eks_cluster_role_arn" {
  value = aws_eks_cluster.this.role_arn
}

output "eks_cluster_name" {
  value = aws_eks_cluster.this.name
}

output "eks_role_arn" {
  value = aws_iam_role.this.arn
}

output "aws_iam_openid_connect_provider_arn" {
  value = aws_iam_openid_connect_provider.oidc_provider.arn
}

output "aws_iam_openid_connect_provider_extracted_arn" {
  value = element(split("oidc-provider/", "${aws_iam_openid_connect_provider.oidc_provider.arn}"), 1)
}

output "aws_iam_role_arn" {
  value = aws_iam_role.eks_nodegroup_role.arn
}


output  "lbc_iam_policy_arn" {
  value = aws_iam_policy.alb_policy.arn
}

output "lbc_iam_role_arn" {
  value = aws_iam_role.alb_role.arn
}

output "lbc_helm_metadata" {
  value = helm_release.loadbalancer_controller.metadata
}