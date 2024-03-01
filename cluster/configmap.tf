resource "kubernetes_config_map_v1" "aws_auth" {
  depends_on = [ aws_eks_cluster.this ]
  metadata {
    name = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = var.configmap_roles
    mapUsers = var.configmap_users
  }
}