# ----------------------------
# VPC and Subnet Data Sources
# ----------------------------
data "aws_vpc" "main" {
  tags = {
    Name = "Master-vpc"
  }
}

data "aws_subnets" "all_subnets" {
  filter {
    name = "tag:Name"
    values = ["Subnet-A","Subnet-B","Subnet-C","Subnet-D"]
  }
}

data "aws_security_group" "main_sg" {
  vpc_id = data.aws_vpc.main.id
  filter {
    name = "tag:Name"
    values = [ "Master-sg" ]
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = var.eks_cluster_name
  cluster_version = "1.30"

  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id     = data.aws_vpc.main.id
  subnet_ids = data.aws_subnets.all_subnets.ids

  eks_managed_node_groups = {
    cluster_node = {
      min_size     = 2
      max_size     = 10
      desired_size = 3

      instance_types = ["t3.large"]
    }
  }

  manage_aws_auth_configmap = true
}

