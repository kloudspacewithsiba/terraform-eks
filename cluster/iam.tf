resource "aws_iam_role" "this" {
  name = "${var.eks_name}-eks-master-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role = aws_iam_role.this.name
}

resource "aws_iam_role" "eks_nodegroup_role" {
  name = "${var.eks_name}-ng-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

}

resource "aws_iam_policy_attachment" "eks_AmazonEKSWorkerNodePolicy" {
  name       = "eks_AmazonEKSWorkerNodePolicy"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  roles      = [aws_iam_role.eks_nodegroup_role.name]
}

resource "aws_iam_policy_attachment" "eks_AmazonEKSCNIPolicy" {
  name       = "eks_AmazonEKSCNIPolicy"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  roles      = [aws_iam_role.eks_nodegroup_role.name]
}

resource "aws_iam_policy_attachment" "eks_AmazonEC2ContainerRegistryReadOnly" {
  name       = "eks_AmazonEC2ContainerRegistryReadOnly"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  roles      = [aws_iam_role.eks_nodegroup_role.name]
}

resource "aws_iam_policy_attachment" "eks_AmazonAutoScalingFullAccessPolicy" {
  name       = "eks_AmazonAutoScalingFullAccessPolicy"
  policy_arn = "arn:aws:iam::aws:policy/AutoScalingFullAccess"
  roles      = [aws_iam_role.eks_nodegroup_role.name]
}

resource "aws_iam_policy_attachment" "eks_AmazonCloudwatchContainerInsightsPolicy" {
  name       = "eks_AmazonCloudwatchContainerInsightsPolicy"
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  roles      = [aws_iam_role.eks_nodegroup_role.name]
}


