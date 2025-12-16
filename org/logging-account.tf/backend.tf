############################################################
# TERRAFORM REMOTE BACKEND (S3 + DYNAMODB LOCKING)
############################################################

terraform {
  backend "s3" {
    bucket         = "aws-3-tier-state"
    key            = "logging-account/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    use_lockfile = "terraform-state-lock"
    role_arn       = "arn:aws:iam::<SECURITY_ACCOUNT_ID>:role/TerraformBackendRole"
  }
}
