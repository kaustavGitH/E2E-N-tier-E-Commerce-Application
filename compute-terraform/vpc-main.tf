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

resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnet_cidr)
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_subnet_cidr[count.index]
  availability_zone       = data.aws_availability_zones.available_azs.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = var.public_subnet_name[count.index]
    Environment = "prod"
    Creator     = "terraform"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnet_cidr)
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.available_azs.names[count.index]

  tags = {
    Name        = var.private_subnet_name[count.index]
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

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name        = "public-${var.route_table_name}"
    Environment = "prod"
    Creator     = "terraform"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.public_nat.id
  }

  tags = {
    Name        = "private-${var.route_table_name}"
    Environment = "prod"
    Creator     = "terraform"
  }
}

resource "aws_route_table_association" "public_rta" {
  count          = length(var.public_subnet_cidr)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_rta" {
  count          = length(var.private_subnet_cidr)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_eip" "main_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "public_nat" {
  subnet_id     = aws_subnet.public_subnet[0].id
  allocation_id = aws_eip.main_eip.id
}
