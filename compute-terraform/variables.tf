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
  description = "CIDR blocks for public subnet"
  type = list(string)
  default = [ "172.168.1.0/24","172.168.2.0/24" ]
}

variable "private_subnet_cidr" {
  description = "CIDR blocks for private subnet"
  type = list(string)
  default = [ "172.168.10.0/24", "172.168.11.0/24" ]
}

variable "public_subnet_name" {
  description = "Name of the public subnets"
  type = list(string)
  default = [ "public-subnet-A","public-subnet-B" ]
}

variable "private_subnet_name" {
  description = "Name of the private subnets"
  type = list(string)
  default = [ "private-subnet-A","private-subnet-B" ]
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
