############################################################
# ORGANIZATION ACCOUNT IDs (FOR CROSS-ACCOUNT ACCESS)
############################################################

output "security_account_id" {
  description = "AWS Account ID for the Security Account"
  value       = aws_organizations_account.security.id
}

output "logging_account_id" {
  description = "AWS Account ID for the Logging Account"
  value       = aws_organizations_account.logging.id
}

output "workload_account_id" {
  description = "AWS Account ID for the Workload Account"
  value       = aws_organizations_account.workload.id
}

output "organization_id" {
  description = "AWS Organization ID"
  value       = aws_organizations_organization.main.id
}

output "organization_arn" {
  description = "AWS Organization ARN"
  value       = aws_organizations_organization.main.arn
}
