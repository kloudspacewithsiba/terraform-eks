resource "random_id" "this" {
  keepers = {
    node_group_name = var.eks_name
  }
  byte_length = 8
}


resource "aws_eks_node_group" "this" {
  depends_on = [
    aws_iam_policy_attachment.eks_AmazonEC2ContainerRegistryReadOnly,
    aws_iam_policy_attachment.eks_AmazonEKSCNIPolicy,
    aws_iam_policy_attachment.eks_AmazonEKSWorkerNodePolicy,
    aws_eks_cluster.this
  ]
  cluster_name    = var.eks_name
  node_group_name = "${var.eks_name}-eks-ng-${random_id.this.hex}"
  node_role_arn   = aws_iam_role.eks_nodegroup_role.arn
  subnet_ids      = var.subnet_ids
  version         = var.eks_version
  ami_type        = var.ami_type
  capacity_type   = var.capacity_type
  disk_size       = 20
  instance_types  = var.instance_types
  scaling_config {
    desired_size = var.scaling_config.desired_size
    min_size     = var.scaling_config.min_size
    max_size     = var.scaling_config.max_size
  }
  update_config {
    max_unavailable = 1
  }


  tags = {
    Name = "${var.eks_name}-private-node-group"
    "k8s.io/cluster-autoscaler/${var.eks_name}" = "owned"
    "k8s.io/cluster-autoscaler/enabled" = "TRUE"
  }
}
