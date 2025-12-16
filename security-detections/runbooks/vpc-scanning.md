# 🚨 VPC Network Scanning

## Severity
MEDIUM

## Trigger
- High volume of rejected traffic
- Unusual destination ports detected

## Why This Matters
May indicate:
- Reconnaissance activity
- Misconfigured services
- Lateral movement attempts

## Investigation Steps
1. Identify source and destination IPs
2. Review ports involved
3. Correlate with GuardDuty findings

## Containment
1. Block source IP using NACL or SG
2. Restrict exposed ports

## Remediation
- Review VPC security groups
- Harden network segmentation

## DLQ Handling
If alert delivery fails:
1. Check SQS queue: soc-security-alerts-dlq
2. Identify failed event
3. Fix SNS / IAM / subscription issue
4. Replay event manually if required

## Related MITRE ATT&CK
- T1046 – Network Service Scanning
