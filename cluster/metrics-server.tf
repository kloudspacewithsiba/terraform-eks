# resource "helm_release" "metrics_server" {
#   depends_on = [ aws_eks_cluster.this, aws_eks_node_group.this ]
#   name = "${var.eks_name}-metrics-server"
#   repository = "https://kubernetes-sigs.github.io/metrics-server"
#   chart = "metrics-server"
#   namespace = "kube-system"
# }