🚨 Runbook: SOC Alerting DLQ Incident

📌 Purpose

This runbook provides response procedures when the SOC alerting Dead Letter Queue (DLQ) contains messages, indicating a failure in alert delivery.

DLQ alerts represent a monitoring pipeline failure, not a security threat, but they are high priority because they may prevent security alerts from reaching responders.

⸻

🔍 Trigger Condition
	•	CloudWatch alarm: soc-dlq-messages-present
	•	Condition: One or more messages present in the DLQ

⸻

🎯 Impact
	•	Security alerts may not be delivered
	•	SOC visibility may be degraded
	•	Potential missed incidents if not addressed promptly

Severity: High (Operational)

⸻

🧠 Investigation Steps
	1.	Confirm DLQ alarm in CloudWatch
	2.	Identify the affected DLQ queue
	3.	Check message count and age
	4.	Inspect failed messages to determine source
	5.	Identify which service failed to deliver:
	•	SNS
	•	OpenSearch monitor
	•	EventBridge (if used)
	6.	Review IAM permissions related to alert delivery
	7.	Check service quotas and throttling limits

⸻

🛠️ Containment Actions
	•	Temporarily disable affected alert monitors if necessary
	•	Manually notify SOC stakeholders if critical alerts are blocked
	•	Ensure no security alerts are silently dropped

⸻

🔄 Remediation Steps
	•	Fix permission or configuration issues
	•	Reprocess DLQ messages if applicable
	•	Confirm successful delivery to SNS
	•	Validate email or integration endpoints
	•	Clear DLQ after resolution

⸻

✅ Validation
	•	Confirm DLQ message count returns to zero
	•	Verify test alerts are successfully delivered
	•	Close CloudWatch alarm

⸻

📘 Lessons Learned
	•	Document root cause
	•	Identify whether retries or thresholds need tuning
	•	Consider alert delivery redundancy if recurrence occurs

⸻

🔗 Related Components
	•	CloudWatch Alarm: DLQ monitoring
	•	SNS Topics: soc-alerts-high
	•	OpenSearch Monitors
	•	Security Lake telemetry

⸻

🧠 SOC Note

Alert delivery is as critical as detection.
A healthy SOC pipeline ensures no threats go unnoticed.
