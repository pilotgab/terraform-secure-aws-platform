############################################################
# BACKEND BOOTSTRAP (RUN ONCE LOCALLY)
############################################################
resource "aws_s3_bucket" "tf_state" {
  bucket = "aws-3-tier-state"

  lifecycle {
    prevent_destroy = true
  }
}

############################
# S3 BUCKET – ACCESS LOGS
############################
resource "aws_s3_bucket" "tf_state_logs" {
  bucket = "aws-3-tier-state-access-logs"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state_logs" {
  bucket = aws_s3_bucket.tf_state_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

############################
# ENABLE ACCESS LOGGING
############################
resource "aws_s3_bucket_logging" "tf_state" {
  bucket        = aws_s3_bucket.tf_state.id
  target_bucket = aws_s3_bucket.tf_state_logs.id
  target_prefix = "access-logs/"
}

resource "aws_s3_bucket_versioning" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "tf_lock" {
  name         = "terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
