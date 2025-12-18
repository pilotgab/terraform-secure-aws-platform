# 🚨 Root Account Usage Detection

## Severity
Critical

## Trigger

• OpenSearch alert indicating root account activity
• CloudTrail event where user.identity.type = Root

⸻

## Why This Matters

The AWS root account has unrestricted privileges and bypasses IAM controls.
Any use of the root account significantly increases blast radius and may indicate:

• Credential compromise
• Policy bypass
• Accidental or unauthorized administrative access
• Elevated financial and operational risk

Root account usage is treated as a zero-tolerance event.

⸻

## Investigation Steps

1. Identify the source IP address from CloudTrail
2. Review all API actions performed during the session
3. Verify whether MFA was used
4. Confirm the time, region, and duration of activity
5. Determine whether the activity was authorized or expected
6. Correlate with other security signals (GuardDuty, VPC Flow Logs)

⸻

## Containment Actions

1. Immediately rotate root account credentials
2. Enable or re-enforce MFA on the root account
3. Restrict root permissions using Service Control Policies where feasible
4. Temporarily suspend sensitive operations if compromise is suspected

⸻

## Remediation Steps

• Perform a full IAM audit (users, roles, policies)
• Review recent infrastructure changes and deployments
• Rotate any potentially exposed credentials
• Update internal security policies and access procedures
• Educate stakeholders on root account usage policies

⸻

## Validation

• Confirm no further root account activity occurs
• Verify MFA enforcement is active
• Ensure all remediation actions are completed
• Close alert once environment integrity is restored

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

• T1078 – Valid Accounts

⸻

## SOC Note

Root account access should be extremely rare.
Every occurrence must be investigated, documented, and justified.
