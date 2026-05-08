resource "aws_iam_policy" "s3_policy" {
  name = "s3-access-policy"
  description = "policy for accessing s3 remote backend"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "s3:*",
            "eks:*",
            "ec2:*"
          ],
          "Resource" : [
            "*"
          ]
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "s3_policy_attachment" {
  policy_arn = aws_iam_policy.s3_policy.arn
  role = aws_iam_role.demo_role.name
}

resource "aws_iam_role_policy_attachment" "ec2_AmazonEC2FullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  role = aws_iam_role.demo_role.name
}

resource "aws_iam_role_policy_attachment" "ec2_IAMFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
  role = aws_iam_role.demo_role.name
}

resource "aws_iam_role_policy_attachment" "ec2_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = aws_iam_role.demo_role.name
}

resource "aws_iam_role_policy_attachment" "ec2_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = aws_iam_role.demo_role.name
}

resource "aws_iam_role_policy_attachment" "ec2_AWSCloudFormationFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCloudFormationFullAccess"
  role = aws_iam_role.demo_role.name
}