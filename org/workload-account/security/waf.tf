############################################################
# AWS WAFv2 (PROTECT ALB)
############################################################
resource "aws_wafv2_web_acl" "alb_waf" {
  name  = "alb-waf"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "aws-managed-common-rules"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "alb-waf"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl_association" "alb" {
  resource_arn = aws_lb.public.arn
  web_acl_arn  = aws_wafv2_web_acl.alb_waf.arn
}


############################################################
# WAF LOGGING: CLOUDWATCH LOGS + S3
############################################################

############################
# CloudWatch Log Group
############################
resource "aws_cloudwatch_log_group" "waf" {
  name              = "/aws/waf/alb-waf"
  retention_in_days = 30
}

############################
# Kinesis Firehose (WAF → S3)
############################
resource "aws_s3_bucket" "waf_logs" {
  bucket = "pilotgab-waf-logs"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "waf_logs" {
  bucket = aws_s3_bucket.waf_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_iam_role" "firehose_role" {
  name = "waf-firehose-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "firehose.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "firehose_policy" {
  role = aws_iam_role.firehose_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:PutObject", "s3:AbortMultipartUpload", "s3:GetBucketLocation", "s3:ListBucket"],
        Resource = [aws_s3_bucket.waf_logs.arn, "${aws_s3_bucket.waf_logs.arn}/*"]
      },
      {
        Effect   = "Allow"
        Action   = ["logs:PutLogEvents"],
        Resource = "*"
      }
    ]
  })
}

resource "aws_kinesis_firehose_delivery_stream" "waf" {
  name        = "waf-logs-stream"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.waf_logs.arn

    buffering_size     = 5
    buffering_interval = 300
  }
}

############################
# WAF Logging Configuration
############################
resource "aws_wafv2_web_acl_logging_configuration" "alb" {
  resource_arn = aws_wafv2_web_acl.alb_waf.arn

  log_destination_configs = [
    aws_kinesis_firehose_delivery_stream.waf.arn,
    aws_cloudwatch_log_group.waf.arn
  ]
}
