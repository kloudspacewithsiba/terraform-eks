module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name                               = var.vpc_name
  cidr                               = var.vpc_cidr
  azs                                = ["${var.region}a", "${var.region}b", "${var.region}c"]
  public_subnets                     = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k)]
  private_subnets                    = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 4)]
  database_subnets                   = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 8)]
  create_database_subnet_group       = true
  create_database_subnet_route_table = true
  enable_nat_gateway                 = true
  single_nat_gateway                 = true
  default_vpc_enable_dns_hostnames   = true
  default_vpc_enable_dns_support     = true
  map_public_ip_on_launch            = true

  public_subnet_tags = {
    Type                                    = "${var.vpc_name}-public-subnets"
    "kubernetes.io/role/elb"                = 1
    "kubernetes.io/cluster/${var.vpc_name}" = "shared"
  }

  private_subnet_tags = {
    Type                                    = "${var.vpc_name}-private-subnets"
    "kubernetes.io/role/internal-elb"       = 1
    "kubernetes.io/cluster/${var.vpc_name}" = "shared"
  }

  database_subnet_tags = {
    Type = "${var.vpc_name}-database-subnets"
  }

  vpc_tags = {
    Name = "${var.vpc_name}"
  }

  tags = var.tags
}
