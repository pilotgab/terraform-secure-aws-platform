variable "security_account_id" {
  description = "The AWS account ID for the security account."
  type        = string
}

variable "acm_certificate_arn" {
  description = "The ARN of the ACM certificate for the ALB."
  type        = string
}

variable "ami" {
  description = "The AMI to use for the EC2 instances."
  type        = string
}

variable "vpc_flow_logs_bucket_arn" {
  description = "The ARN of the S3 bucket for VPC flow logs."
  type        = string
}

variable "vpc_flow_logs_role_arn" {
  description = "The ARN of the IAM role for VPC flow logs."
  type        = string
}

variable "db_user" {
  description = "The username for the RDS database."
  type        = string
}

variable "db_password" {
  description = "The password for the RDS database."
  type        = string
  sensitive   = true
}
