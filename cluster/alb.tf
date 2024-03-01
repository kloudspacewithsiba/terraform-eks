resource "aws_iam_policy" "alb_policy" {
    name = "${var.eks_name}-AWSLoadBalancerControllerIAMPolicy"
    path = "/"
    description = "AWS Load Balancer Controller IAM Policy"
    policy = file("${path.module}/policy.json")
}

resource "aws_iam_role" "alb_role" {
  name = "${var.eks_name}-lbc-iam-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Federated = "${aws_iam_openid_connect_provider.oidc_provider.arn}"
        }
        Condition = {
          StringEquals = {
            "${element(split("oidc-provider/", "${aws_iam_openid_connect_provider.oidc_provider.arn}"), 1)}:aud": "sts.amazonaws.com",
            "${element(split("oidc-provider/", "${aws_iam_openid_connect_provider.oidc_provider.arn}"), 1)}:sub": "system:serviceaccount:kube-system:aws-elb-service-account"
          }
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "this" {
  policy_arn = aws_iam_policy.alb_policy.arn
  role       = aws_iam_role.alb_role.name
}


resource "kubernetes_ingress_class_v1" "ingress_class_default" {
  depends_on = [helm_release.loadbalancer_controller]
  metadata {
    name = "aws-elb-service-account"
    annotations = {
      "ingressclass.kubernetes.io/is-default-class" = "true"
    }
  }
  spec {
    controller = "ingress.k8s.aws/alb"
  }
}


resource "helm_release" "loadbalancer_controller" {
  depends_on = [ aws_eks_node_group.this ]
  name = "aws-load-balancer-controller"

  repository = "https://aws.github.io/eks-charts"
  chart = "aws-load-balancer-controller"

  namespace = "kube-system"

  set {
    name = "image.repository"
    value = "602401143452.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/amazon/aws-load-balancer-controller"
  }

  set {
    name = "serviceAccount.create"
    value = "true"
  }

  set {
    name = "serviceAccount.name"
    value = "aws-elb-service-account"
  }

  set {
    name = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "${aws_iam_role.alb_role.arn}"
  }

  set {
    name = "vpcId"
    value = var.vpc_id
  }

  set {
    name = "region"
    value = data.aws_region.current.name
  }

  set {
    name = "clusterName"
    value = var.eks_name
  }
}
