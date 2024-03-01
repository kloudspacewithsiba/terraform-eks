# resource "kubernetes_namespace_v1" "monitoring" {
#   metadata {
#     name = "monitoring"
#   }
# }

# resource "helm_release" "kube_prometheus_stack" {
#   depends_on = [ kubernetes_namespace_v1.monitoring, aws_eks_cluster.this, aws_eks_node_group.this ]
#   name       = "kube-prometheus-stack"
#   namespace  = "monitoring"
#   version    = "54.2.1"
#   repository = "https://prometheus-community.github.io/helm-charts"
#   chart      = "kube-prometheus-stack"
# }