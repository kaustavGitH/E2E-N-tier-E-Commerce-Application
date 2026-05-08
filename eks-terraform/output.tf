output "subnet_ids" {
  value = data.aws_subnets.all_subnets.ids
}

output "security_group_id" {
  value = data.aws_security_group.eks_sg.id
}