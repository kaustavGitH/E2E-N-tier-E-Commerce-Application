resource "aws_security_group" "main_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress = [
    for port in [22, 53, 80, 443, 5050, 7000, 7070, 8080, 9000, 9090, 9555, 3600, 3550, 50051, 10250] : {
      description = "Incoming traffic into VPC"
      from_port   = port
      to_port     = port
      protocol    = "TCP"
      cidr_blocks  = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups =[]
      self = false
    }
  ]

  egress {
    description = "Outgoing traffic from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = var.sg_name
    Environment = "prod"
    Creator     = "terraform"
  }
}
