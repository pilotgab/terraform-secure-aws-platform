# 🚨 GuardDuty Malware Detection

## Severity
HIGH

## Trigger
- GuardDuty finding with severity HIGH or CRITICAL

## Why This Matters
Indicates potential:
- Malware execution
- Credential compromise
- Data exfiltration

## Investigation Steps
1. Review GuardDuty finding type
2. Identify affected resource (EC2, IAM, S3)
3. Correlate with VPC Flow Logs
4. Check recent IAM activity

## Containment
1. Isolate affected EC2 instance (security group)
2. Snapshot instance for forensics
3. Disable compromised IAM credentials

## Remediation
- Patch vulnerabilities
- Rotate credentials
- Apply least privilege

## DLQ Handling
If alert delivery fails:
1. Check SQS queue: soc-security-alerts-dlq
2. Identify failed event
3. Fix SNS / IAM / subscription issue
4. Replay event manually if required

## Related MITRE ATT&CK
- T1204 – User Execution
