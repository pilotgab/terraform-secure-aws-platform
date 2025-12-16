###########################################################
# MULTI‑ACCOUNT AWS ORGANIZATIONS SETUP
############################################################
resource "aws_organizations_organization" "main" {
  feature_set = "ALL"
}

resource "aws_organizations_account" "security" {
  name  = "security-account"
  email = var.security_email
}

resource "aws_organizations_account" "logging" {
  name  = "logging-account"
  email = var.logging_email
}

resource "aws_organizations_account" "workload" {
  name  = "workload-account"
  email = var.workload_email
}
