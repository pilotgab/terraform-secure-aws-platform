# This is a read only role to be attached to Security Engineers or SOC Analysts
resource "aws_iam_policy" "opensearch_read" {
  name = "SecurityAnalyticsReadOnly"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "es:ESHttpGet",
        "es:ESHttpPost"
      ]
      Resource = "${aws_opensearch_domain.security.arn}/*"
    }]
  })
}
