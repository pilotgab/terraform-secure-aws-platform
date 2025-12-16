resource "aws_s3_bucket" "web_app" {
  bucket = "pilotgab-web-app"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "web_app" {
  bucket = aws_s3_bucket.web_app.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "web_app" {
  bucket = aws_s3_bucket.web_app.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "web_app" {
  bucket = aws_s3_bucket.web_app.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "app_files" {
  for_each = fileset("${path.module}/web-app", "**/*")

  bucket = aws_s3_bucket.web_app.id
  key    = each.value
  source = "${path.module}/web-app/${each.value}"

  etag = filemd5("${path.module}/web-app/${each.value}")
}
