resource "aws_cloudwatch_event_rule" "opensearch_alerts" {
  name        = "opensearch-alert-events"
  description = "Routes OpenSearch security alerts"
  event_pattern = jsonencode({
    source = ["aws.opensearch"]
  })
}

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.opensearch_alerts.name
  target_id = "send-to-sns"
  arn       = aws_sns_topic.critical.arn
}
