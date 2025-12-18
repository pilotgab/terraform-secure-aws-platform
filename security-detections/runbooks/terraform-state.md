# 🚨 Terraform State Access Detection

## Severity
High

## Trigger

• Access to terraform.tfstate files outside approved CI/CD or backend roles
• CloudTrail event indicating S3 object access to Terraform state

⸻

## Why This Matters

Terraform state files stored in remote backends (S3) may contain:

• Sensitive infrastructure metadata
• IAM role and resource ARNs
• Provider configuration details
• Embedded secrets or outputs

Unauthorized access to Terraform state can lead to full infrastructure compromise.

⸻

## Investigation Steps

1. Identify the IAM principal that accessed the state file
2. Review CloudTrail event details (action, bucket, object key)
3. Validate source IP address and request time
4. Confirm whether access aligns with expected CI/CD activity
5. Review recent Terraform runs and backend logs

⸻

## Containment Actions

1. Immediately revoke or disable offending credentials
2. Restrict Terraform backend access to approved CI/CD roles only
3. Rotate any potentially exposed secrets or credentials
4. Temporarily lock state file access if compromise is suspected

⸻

## Remediation Steps

• Review and tighten IAM policies for the Terraform backend
• Enforce least privilege on S3 and DynamoDB state locking
• Ensure CloudTrail data events are enabled for state buckets
• Apply Service Control Policies to limit unauthorized access where feasible

⸻

## Validation

• Confirm no further unauthorized state access occurs
• Verify Terraform operations function correctly via CI/CD roles
• Ensure secrets rotation and access restrictions are complete
• Close alert once state integrity is confirmed

⸻

## DLQ Handling (Alert Delivery Failure)

If the alert was not delivered successfully:

1. Check SQS queue: soc-security-alerts-dlq
2. Identify failed alert messages
3. Investigate SNS, IAM, or notification destination issues
4. Manually notify SOC stakeholders if required
5. Clear DLQ messages after delivery is restored

⸻

## Related MITRE ATT&CK

• T1552 – Unsecured Credentials

⸻

## SOC Note

Terraform state is a high-value target.
Access must be tightly controlled, monitored, and audited at all times.
