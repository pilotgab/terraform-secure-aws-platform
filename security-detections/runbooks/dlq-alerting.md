🚨 Runbook: SOC Alerting DLQ Incident

📌 Purpose

This runbook defines response procedures when the SOC alerting Dead Letter Queue (DLQ)
contains messages, indicating a failure in the alert delivery pipeline.

DLQ alerts represent an operational monitoring failure rather than a direct security
incident. However, they are treated as high priority because failed delivery may prevent
security alerts from reaching responders.

⸻

🔍 Trigger Condition

• CloudWatch alarm: soc-dlq-messages-present
• Condition: One or more messages present in the DLQ

⸻

🎯 Impact

• Security alerts may not be delivered to responders
• SOC visibility may be degraded
• Potential missed or delayed incident response

Severity: High (Operational)

⸻

🧠 Investigation Steps

1. Confirm the DLQ alarm state in CloudWatch
2. Identify the affected SQS DLQ queue
3. Check message count and oldest message age
4. Inspect sample messages to identify the failure source
5. Determine which component failed to deliver alerts:
   • OpenSearch notification destination
   • SNS topic or subscription
   • IAM permissions associated with alert delivery
6. Review recent configuration or IAM changes
7. Check service quotas, throttling, or regional service issues

⸻

🛠️ Containment Actions

• Manually notify SOC stakeholders if critical alerts may be blocked
• Temporarily pause affected OpenSearch monitors if misfiring
• Ensure no high-severity security alerts are silently dropped

⸻

🔄 Remediation Steps

• Fix IAM permission or configuration issues
• Validate OpenSearch notification destinations
• Confirm SNS topic and subscription health
• Reprocess or manually review DLQ messages if required
• Clear DLQ messages only after resolution is confirmed

⸻

✅ Validation

• Confirm DLQ message count returns to zero
• Trigger a test alert from OpenSearch
• Verify successful delivery to SNS and email recipients
• Confirm CloudWatch alarm returns to OK state

⸻

📘 Lessons Learned

• Document root cause and remediation steps
• Identify whether retries, thresholds, or permissions require tuning
• Evaluate whether alert delivery resilience needs improvement

⸻

🔗 Related Components

• CloudWatch Alarm: DLQ monitoring
• SQS DLQ: soc-security-alerts-dlq
• SNS Topics: soc-alerts-high
• OpenSearch monitors and notification destinations
• AWS Security Lake telemetry

⸻

🧠 SOC Note

Detection without delivery is failure.

A healthy SOC pipeline ensures that every critical alert
reaches a human responder without delay.
