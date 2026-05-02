variable "instance_ami" {
  description = "Ami id for the instance"
  type        = string
  default     = "ami-091138d0f0d41ff90"
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
  default = [ "10.0.1.0/24","10.0.2.0/24","10.0.3.0/24","10.0.4.0/24" ]
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
