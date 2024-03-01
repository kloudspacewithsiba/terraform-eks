locals {
  region = "eu-west-2"
  profile = "siba"

  common_tags = {
    Billing = "Cloud"
    Environment = "prod"
    ConfigManagement = "Terraform"
    Site = "eks"
    Owner = "DevOps"
  }

    mapRoles = yamlencode([
    {
      rolearn  = "${module.eks_cluster.aws_iam_role_arn}"
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:bootstrappers", "system:nodes", "system:masters"]
    },
    # {
    #   rolearn = module.eks.eks_readonly_role_arn
    #   username = "eks-readonly"
    #   groups = ["${module.eks.eks_cluster_role_subject_name}"]
    # }
  ])

  mapUsers = yamlencode([
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/Sibabalwe"
      username = "Sibabalwe"
      groups   = ["system:masters"]
    }
  ])
}