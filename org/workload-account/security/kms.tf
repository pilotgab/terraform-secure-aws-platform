resource "aws_kms_key" "rds" {
  description         = "KMS key for RDS encryption"
  enable_key_rotation = true
}
