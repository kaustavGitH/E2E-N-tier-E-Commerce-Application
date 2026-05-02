output "subnet_ids" {
  value = data.aws_subnets.all_subnets.ids
}