resource "aws_security_group" "main_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress = [
    for port in [22, 80, 443, 8080, 9000, 9090, 3600] : {
        description = "Incoming traffic into VPC"
        from_port = port
        to_port = port
        protocol = "TCP"
        cidr_block = ["0.0.0.0/0"]
    }
  ]

  egress{
    description = "Outgoing traffic from VPC"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = "prod"
    Creator     = "terraform"
  }
}