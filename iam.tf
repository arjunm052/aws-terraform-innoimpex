resource "aws_iam_role" "eks-node-role" {
  name = var.iam_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = {
    Name = "EKS-Worker-Node-Role"
  }
}

resource "aws_iam_role_policy_attachment" "eks-node-role_policy" {
  for_each   = var.iam_policy_arns
  role       = aws_iam_role.eks-node-role.name
  policy_arn = each.value
}

resource "aws_iam_instance_profile" "eks-node-role-instance-profile" {
  name = var.iam_name
  role = aws_iam_role.eks-node-role.name
}
