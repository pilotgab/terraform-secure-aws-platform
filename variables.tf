variable "region" {}
variable "ami" {}
variable "db_user" {}
variable "db_password" {}
variable "logging_email" {}
variable "security_email" {}
variable "vpc_flow_logs_bucket_arn" {}
# vpc_flow_logs_role_arn removed - not needed for S3 destination

variable "workload_email" {}

variable "acm_certificate_arn" {}

