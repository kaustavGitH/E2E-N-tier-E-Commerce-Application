# ----------------------------
# IAM Role for EKS Cluster
# ----------------------------
resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-iam-role1"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "eks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster_role.name
}

# ----------------------------
# IAM Role for Worker Nodes
# ----------------------------
resource "aws_iam_role" "eks_node_role" {
  name = "eks-worker-iam-role1"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "autoscaler" {
  name = "eks-autoscaler-policy1"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = [
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeAutoScalingInstances",
        "autoscaling:DescribeTags",
        "autoscaling:DescribeLaunchConfigurations",
        "autoscaling:SetDesiredCapacity",
        "autoscaling:TerminateInstanceInAutoScalingGroup",
        "ec2:DescribeLaunchTemplateVersions"
      ],
      Effect   = "Allow",
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonSSMManagedInstanceCore" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "S3ReadOnlyAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "autoscaler" {
  policy_arn = aws_iam_policy.autoscaler.arn
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_instance_profile" "worker_profile" {
  name = "kaustav_eks_worker_profile"
  role = aws_iam_role.eks_node_role.name
  depends_on = [ aws_iam_role.eks_node_role ]
}

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

# ----------------------------
# EKS Cluster
# ----------------------------
resource "aws_eks_cluster" "main_eks" {
  name = var.eks_cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version = "1.33"

  vpc_config {
    subnet_ids = data.aws_subnets.all_subnets.ids
    security_group_ids = [ data.aws_security_group.main_sg.id ]
  }

  tags = {
    Name = var.eks_cluster_name
    Environment = "prod"
    Creator = "terraform"
  }

  depends_on = [
     aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
     aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
     aws_iam_role_policy_attachment.AmazonEKSVPCResourceController
    ]
}

# ----------------------------
# EKS Node Group
# ----------------------------
resource "aws_eks_node_group" "node-grp" {
  cluster_name = aws_eks_cluster.main_eks.name
  node_group_name = var.node_group_name
  node_role_arn = aws_iam_role.eks_node_role.arn
  subnet_ids = data.aws_subnets.all_subnets.ids
  capacity_type = "ON_DEMAND"
  disk_size = 20
  instance_types = [ "t3.large" ]

  scaling_config {
    desired_size = 2
    max_size = 5
    min_size = 1
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [ 
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonSSMManagedInstanceCore,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.autoscaler
   ]
}
