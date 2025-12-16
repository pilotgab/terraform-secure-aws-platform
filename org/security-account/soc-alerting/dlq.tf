############################################################
# EVENTBRIDGE DEAD-LETTER QUEUE (DLQ)
############################################################

resource "aws_sqs_queue" "soc_alerts_dlq" {
  name                      = "soc-security-alerts-dlq"
  message_retention_seconds = 1209600

  tags = {
    Purpose = "EventBridge DLQ for failed security alerts"
    Owner   = "SOC"
  }
}
