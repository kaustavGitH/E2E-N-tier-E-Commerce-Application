resource "aws_iam_instance_profile" "iam_instance" {
  name = "kaustav_ec2_profile"
  role = aws_iam_role.iam_role.name
}