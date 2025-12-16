############################################################
# Security Hub – Enable Service
############################################################
resource "aws_securityhub_account" "main" {}

############################################################
# Security Hub – CIS AWS Foundations Benchmark enabled
############################################################
resource "aws_securityhub_standards_subscription" "cis" {
  standards_arn = "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.4.0"
}
