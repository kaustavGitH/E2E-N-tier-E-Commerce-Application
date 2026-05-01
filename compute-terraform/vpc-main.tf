resource "aws_vpc" "main_vpc" {
  cidr_block           = "172.168.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = var.vpc_name
    Environment = "prod"
    Creator     = "terraform"
  }
}

data "aws_availability_zones" "available_azs" {
  state = "available"
}

resource "aws_subnet" "main_subnet" {
  count                   = length(var.public_subnet_cidr)
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_subnet_cidr[count.index]
  availability_zone       = data.aws_availability_zones.available_azs.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = var.subnet_name[count.index]
    Environment = "prod"
    Creator     = "terraform"
  }
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name        = var.igw_name
    Environment = "prod"
    Creator     = "terraform"
  }
}

resource "aws_route_table" "main_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route = {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name        = var.route_table_name
    Environment = "prod"
    Creator     = "terraform"
  }
}

resource "aws_route_table_association" "main_rta" {
  count          = length(var.public_subnet_cidr)
  subnet_id      = aws_subnet.main_subnet[count.index].id
  route_table_id = aws_route_table.main_rt.id
}
