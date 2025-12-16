############################################################
# SECURITY LAKE – CLOUDTRAIL SOURCE (ORG-WIDE)
############################################################
resource "aws_securitylake_aws_log_source" "cloudtrail" {
  source_name    = "CLOUD_TRAIL"
  source_version = "2.0"
  accounts       = ["ALL"]
  regions        = ["ALL"]
}

############################################################
# SECURITY LAKE – GUARDDUTY SOURCE
############################################################
resource "aws_securitylake_aws_log_source" "guardduty" {
  source_name    = "GUARD_DUTY"
  source_version = "2.0"
  accounts       = ["ALL"]
  regions        = ["ALL"]
}

############################################################
# SECURITY LAKE – VPC FLOW LOGS SOURCE
############################################################
resource "aws_securitylake_aws_log_source" "vpc_flow" {
  source_name    = "VPC_FLOW"
  source_version = "2.0"
  accounts       = ["ALL"]
  regions        = ["ALL"]
}
