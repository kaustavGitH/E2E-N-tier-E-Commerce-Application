variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type = string
  default = "e-commerce-cluster"
}

variable "node_group_name" {
  description = "Name of the EKS cluster node group"
  type = string
  default = "cluster-node"
}

variable "kubernetes_version" {
  description = "Version of kubernetes for eks cluster"
  type = string
  default = "1.33"
}