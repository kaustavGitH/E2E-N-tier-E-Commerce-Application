#--------------------------
# IAM role for EKS cluster
#--------------------------
resource "aws_iam_role" "eks_cluster_role" {
  name = var.eks_cluster_name
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "eks.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

#-----------------------------
# IAM role for EKS node group
#-----------------------------
resource "aws_iam_role" "eks_node_group_role" {
  name = var.node_group_name
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "sts:AssumeRole"
          ],
          "Principal" : {
            "Service" : [
              "ec2.amazonaws.com"
            ]
          }
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "eks-ng-AmazonEKSWorkerNodePolicy" {
  role       = aws_iam_role.eks_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks-ng-AmazonEC2ContainerRegistryReadOnly" {
  role       = aws_iam_role.eks_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "eks-ng-AmazonEKS_CNI_Policy" {
  role       = aws_iam_role.eks_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

#-----------------------------
# Data source for EKS cluster
#-----------------------------

data "aws_subnets" "all_subnets" {
  filter {
    name   = "tag:Name"
    values = ["Subnet-A", "Subnet-B", "Subnet-C", "Subnet-D"]
  }
}

data "aws_security_group" "eks_sg" {
  filter {
    name   = "tag:Name"
    values = ["Master-sg"]
  }
}

#--------------
# EKS Cluster
#--------------

resource "aws_eks_cluster" "ecommerce_eks_cluster" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.kubernetes_version

  vpc_config {
    endpoint_public_access  = true
    endpoint_private_access = true
    security_group_ids      = [data.aws_security_group.eks_sg.id]
    subnet_ids              = data.aws_subnets.all_subnets.ids
  }

  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }

  bootstrap_self_managed_addons = true

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]
}

#----------------
# EKS node Group
#----------------
resource "aws_eks_node_group" "ecommerce_eks_ng" {
  cluster_name    = var.eks_cluster_name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = data.aws_subnets.all_subnets.ids
  instance_types = ["t3.large"]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-ng-AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.eks-ng-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-ng-AmazonEKSWorkerNodePolicy
  ]
}
