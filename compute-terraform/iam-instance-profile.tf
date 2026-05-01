resource "aws_iam_instance_profile" "iam_instance" {
  name = var.iam_user
  role = aws_iam_role.iam_role.name
}