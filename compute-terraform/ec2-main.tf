resource "aws_instance" "main_ec2" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  key_name               = var.key_pair
  subnet_id              = aws_subnet.main_subnet[0].id
  vpc_security_group_ids = [aws_security_group.main_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.iam_instance.name
  root_block_device {
    volume_size = 30
  }

  tags = {
    Name        = var.instance_name
    Environment = "prod"
    Creator     = "terraform"
  }
}
