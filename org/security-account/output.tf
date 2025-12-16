output "vpc_flow_logs_bucket_arn" {
  value = aws_s3_bucket.vpc_flow_logs.arn
}

output "vpc_flow_logs_role_arn" {
  value = aws_iam_role.vpc_flow_logs.arn
}
