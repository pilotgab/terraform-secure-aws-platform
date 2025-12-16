# 🚨 Root Account Usage

## Severity
CRITICAL

## Trigger
- OpenSearch alert: Root account activity detected
- CloudTrail event with `user.identity.type = Root`

## Why This Matters
The AWS root account has unrestricted privileges. Any usage may indicate:
- Credential compromise
- Policy bypass
- Severe misconfiguration

## Investigation Steps
1. Identify source IP from CloudTrail
2. Review API calls performed
3. Check if MFA was used
4. Determine time and region of activity

## Containment
1. Immediately rotate root credentials
2. Enable or enforce MFA on root
3. Restrict root access via SCP (where possible)

## Remediation
- Audit IAM roles and users
- Review recent infrastructure changes
- Update security policies

## DLQ Handling
If alert delivery fails:
1. Check SQS queue: soc-security-alerts-dlq
2. Identify failed event
3. Fix SNS / IAM / subscription issue
4. Replay event manually if required

## Related MITRE ATT&CK
- T1078 – Valid Accounts
