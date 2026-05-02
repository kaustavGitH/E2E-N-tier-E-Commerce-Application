variable "instance_ami" {
  description = "Ami id for the instance"
  type        = string
  default     = "ami-05cf1e9f73fbad2e2"
}

variable "instance_type" {
  description = "Type of instance to create"
  type        = string
  default     = "t3.large"
}

variable "key_pair" {
  description = "Key-pair value to attach to the instance"
  type        = string
  default     = "devops-key"
}

variable "instance_name" {
  description = "Name of the instance"
  type = string
  default = "Master-instance"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type = string
  default = "Master-vpc"
}

variable "public_subnet_cidr" {
  description = "CIDR blocks for vpc subnet"
  type = list(string)
  default = [ "172.168.1.0/24","172.168.2.0/24","172.168.3.0/24","172.168.4.0/24" ]
}

variable "subnet_name" {
  description = "Name of the subnets"
  type = list(string)
  default = [ "Subnet-A","Subnet-B","Subnet-C","Subnet-D" ]
}

variable "route_table_name" {
  description = "Name of the route table"
  type = string
  default = "Master-route-table"
}

variable "igw_name" {
  description = "Name of the internet gateway"
  type = string
  default = "Master-igw"
}

variable "iam_role_name" {
  description = "IAM Role for master server"
  type = string
  default = "Master-server-iam-role1"
}

variable "sg_name" {
  description = "Name of the security group"
  type = string
  default = "Master-sg"
}
