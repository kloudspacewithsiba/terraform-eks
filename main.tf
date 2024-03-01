
/* Virtual Private Cloud */
module "vpc" {
  source = "./network"
  vpc_cidr = "10.0.0.0/16"
  vpc_name = "k8s-prod"
  region = local.region

  tags = local.common_tags
}

/* EKS cluster */
module "eks_cluster" {
  source = "./cluster"
  eks_name = "k8s-prod"
  eks_version = "1.27"
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.vpc_public_subnets

  // Nodes
  ami_type       = "AL2_x86_64"
  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.medium"]
  scaling_config = {
    desired_size = 3
    min_size     = 3
    max_size     = 3
  }

  configmap_roles = local.mapRoles
  configmap_users = local.mapUsers
}