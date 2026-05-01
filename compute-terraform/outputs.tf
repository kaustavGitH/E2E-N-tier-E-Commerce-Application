output "instance_id" {
  description = "ID of the instance"
  
  value = aws_instance.main_ec2.id
}

output "vpc_id" {
  description = "ID of the VPC"
  value = aws_vpc.main_vpc.id
}

output "instance_ip" {
  description = "Public IP of the master instance"
  value = aws_instance.main_ec2.public_ip
}