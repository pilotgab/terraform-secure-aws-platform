output "vpc_flow_logs_bucket_arn" {
  description = "ARN of the S3 bucket for VPC flow logs"
  value       = aws_s3_bucket.vpc_flow_logs.arn
}

# vpc_flow_logs_role_arn output removed - not needed for S3 destination type
