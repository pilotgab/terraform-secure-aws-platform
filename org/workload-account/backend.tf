############################################################
# TERRAFORM REMOTE BACKEND (S3 + DYNAMODB LOCKING)
############################################################

terraform {
  backend "s3" {
    bucket         = "aws-3-tier-state"
    key            = "workload-account/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    use_lockfile = "terraform-state-lock"
    role_arn       = "arn:aws:iam::${var.security_account_id}:role/TerraformBackendRole"
  }
}
