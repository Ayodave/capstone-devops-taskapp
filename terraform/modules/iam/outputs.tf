output "kops_instance_profile_arn" {
  value = aws_iam_instance_profile.kops_cluster.arn
}

output "kops_role_arn" {
  value = aws_iam_role.kops_cluster.arn
}
