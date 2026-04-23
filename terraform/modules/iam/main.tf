resource "aws_iam_role" "kops_cluster" {
  name = "${var.project_name}-kops-cluster"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
  tags = {
    Name = "${var.project_name}-kops-cluster-role"
  }
}

resource "aws_iam_role_policy_attachment" "kops_cluster" {
  role       = aws_iam_role.kops_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_instance_profile" "kops_cluster" {
  name = "${var.project_name}-kops-cluster"
  role = aws_iam_role.kops_cluster.name
}
