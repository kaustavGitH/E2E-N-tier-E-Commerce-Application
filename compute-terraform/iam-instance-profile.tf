resource "aws_iam_instance_profile" "instance_profile" {
  name = "kaustav-instance-profile"
  role = aws_iam_role.demo_role.name
}