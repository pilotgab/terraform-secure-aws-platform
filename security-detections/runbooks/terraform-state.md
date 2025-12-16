# 🚨 Runbook: Terraform State Access

## Severity
HIGH

## Trigger
- Access to `terraform.tfstate` outside approved CI/CD roles

## Why This Matters
Terraform state files may contain:
- Secrets
- IAM role ARNs
- Infrastructure metadata

Unauthorized access can lead to full environment compromise.

## Investigation Steps
1. Identify IAM principal
2. Review CloudTrail event details
3. Validate access time and IP
4. Check recent Terraform executions

## Containment
1. Revoke offending credentials
2. Lock state access to CI/CD roles only
3. Rotate exposed secrets

## Remediation
- Review IAM backend policies
- Enable CloudTrail data events
- Tighten SCPs if needed

## DLQ Handling
If alert delivery fails:
1. Check SQS queue: soc-security-alerts-dlq
2. Identify failed event
3. Fix SNS / IAM / subscription issue
4. Replay event manually if required

## Related MITRE ATT&CK
- T1552 – Unsecured Credentials
