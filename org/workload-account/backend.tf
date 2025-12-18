############################################################
# TERRAFORM REMOTE BACKEND (S3 + DYNAMODB LOCKING)
############################################################

terraform {
  backend "s3" {
    bucket         = "aws-3-tier-state"
    key            = "workload-account/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
    # TODO: Replace <SECURITY_ACCOUNT_ID> with actual security account ID after account creation
    role_arn       = "arn:aws:iam::<SECURITY_ACCOUNT_ID>:role/TerraformBackendRole"
  }
}
