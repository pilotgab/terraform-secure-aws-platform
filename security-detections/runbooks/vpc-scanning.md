# 🚨 VPC Network Scanning / Traffic Anomalies

## Severity
Medium

## Trigger

• High volume of rejected VPC Flow Log traffic
• Unusual or non-standard destination ports detected
• Repeated connection attempts across multiple ports or targets

⸻

## Why This Matters

This activity may indicate:

• Network reconnaissance or port scanning
• Misconfigured services or exposed resources
• Early-stage lateral movement attempts

While not always malicious, this behaviour warrants investigation to prevent escalation.

⸻

## Investigation Steps

1. Identify source IP address and affected destination resources
2. Review destination ports and protocols involved
3. Determine whether traffic originates internally or externally
4. Correlate activity with GuardDuty findings or other alerts
5. Validate whether the traffic aligns with expected application behaviour

⸻

## Containment Actions

1. Block malicious or unauthorized source IPs using Security Groups or NACLs
2. Restrict or close unnecessary exposed ports
3. Apply temporary rate limiting or filtering if required

⸻

## Remediation Steps

• Review and harden Security Group rules
• Improve network segmentation between tiers
• Ensure least-privilege network access policies are enforced
• Validate firewall and routing configurations

⸻

## Validation

• Confirm rejected traffic volume returns to baseline
• Verify no further anomalous connection attempts occur
• Ensure application functionality is not impacted
• Close alert once behaviour is confirmed benign or remediated

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

• T1046 – Network Service Scanning

⸻

## SOC Note

Not all scans are attacks, but all scans deserve visibility.
Early detection prevents escalation.
