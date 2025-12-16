############################################################
# SNS TOPICS BY SEVERITY
############################################################

resource "aws_sns_topic" "critical" {
  name = "soc-alerts-critical"
}

resource "aws_sns_topic" "high" {
  name = "soc-alerts-high"
}

resource "aws_sns_topic" "medium" {
  name = "soc-alerts-medium"
}

resource "aws_sns_topic_subscription" "email_critical" {
  topic_arn = aws_sns_topic.critical.arn
  protocol  = "email"
  endpoint  = "captain.gab@protonmail.com"
}

resource "aws_sns_topic_subscription" "email_high" {
  topic_arn = aws_sns_topic.high.arn
  protocol  = "email"
  endpoint  = "captain.gab@protonmail.com"
}

resource "aws_sns_topic_subscription" "email_medium" {
  topic_arn = aws_sns_topic.medium.arn
  protocol  = "email"
  endpoint  = "captain.gab@protonmail.com"
}
