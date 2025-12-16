############################################################
# TERRAFORM REMOTE BACKEND (S3 + DYNAMODB LOCKING)
############################################################

terraform {
  backend "s3" {
    bucket         = "aws-3-tier-state"
    key            = "security-account/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    use_lockfile   = "terraform-state-lock"
  }
}
