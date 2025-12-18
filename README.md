🚀 																											SECURE MULTI-ACCOUNT AWS PLATFORM WITH TERRAFORM

A production-ready, security-hardened multi-account AWS platform implemented using Terraform. This project demonstrates enterprise-grade DevSecOps, cloud security architecture, SOC-style monitoring, and operational excellence.

⸻

📌 Overview

This repository provisions a secure, scalable, and enterprise-ready AWS platform using Terraform.

It is designed to demonstrate real-world DevSecOps and Cloud Security best practices, aligned with:
	•	AWS Well-Architected Framework
	•	AWS Security Specialty expectations
	•	Architectures commonly used by UK enterprises and regulated environments

The focus is not only on building infrastructure, but on operating it securely in production.

⸻

👥 Intended Audience

This repository is intended for:
	•	Cloud Engineers
	•	Platform Engineers
	•	DevSecOps Engineers
	•	Security Engineers

who want to see how enterprise AWS environments are designed, secured, monitored, and operated in practice.

⸻

🌟 Key Features

🔒 Security First
	•	AWS Organizations with Service Control Policies (SCPs)
	•	Multi-account architecture:
	•	Management
	•	Security
	•	Logging
	•	Workload
	•	IAM least privilege with MFA enforcement
	•	Root account usage prevention and detection
	•	End-to-end encryption (EBS, RDS, S3, EFS) using KMS
	•	Network security with VPCs, NACLs, and security groups
	•	Threat detection via GuardDuty and Security Hub
	•	AWS WAFv2 with OWASP Top 10 protections

⸻

🏗 Infrastructure
	•	Highly available architecture across multiple AZs
	•	Auto Scaling application tier
	•	Application Load Balancer (ALB)
	•	Managed RDS PostgreSQL (private, non-public)
	•	Optional CloudFront integration
	•	Centralised logging via CloudTrail and VPC Flow Logs

⸻

📊 Monitoring, Detection & Compliance
	•	AWS Security Lake for centralised security telemetry
	•	Amazon OpenSearch for security analytics and dashboards
	•	SOC-style alerting with severity classification
	•	CloudWatch for metrics and operational alarms
	•	CIS AWS Foundations Benchmark via Security Hub
	•	Organisation-wide audit trails

⸻

🚨 SOC Alerting Architecture

Security alerting follows real SOC design principles.

Key Design Decision

Security alerts are generated using OpenSearch monitors — not direct EventBridge rules.

This enables:
	•	Rich query-based detections
	•	Thresholding and correlation
	•	SOC-style alert workflows

EventBridge and CloudWatch are used only for operational monitoring of alert delivery failures (DLQ).

⸻

🔁 Alert Flow
AWS Services (IAM, EC2, Network, API Activity)
                ↓
     GuardDuty / CloudTrail / VPC Flow Logs
                ↓
     AWS Security Lake (OCSF Normalised)
                ↓
         Amazon OpenSearch
                ↓
      Detection Monitors (Queries)
                ↓
      Severity-Based Alert Triggers
                ↓
        SNS Topics
   (Critical | High | Medium)
                ↓
     SOC / Email / Integrations
                ↓
     SQS Dead Letter Queue (DLQ)
                ↓
      CloudWatch Alarm (DLQ)

⸻

🔔 Alerting Model
	•	Alerts are severity-classified:
	•	Critical
	•	High
	•	Medium
	•	Each alert:
	•	Maps to a MITRE ATT&CK technique
	•	Has a documented SOC runbook
	•	Routes to a dedicated SNS topic

⸻

🔍 Security Analytics & Monitoring

AWS Security Lake
	•	Centralised collection of security telemetry
	•	Ingests:
	•	CloudTrail
	•	GuardDuty findings
	•	VPC Flow Logs
	•	Normalised using OCSF
	•	Enables cross-account security analysis

⸻

Amazon OpenSearch Security Analytics
	•	Managed OpenSearch cluster
	•	Custom dashboards for:
	•	Threat detection
	•	IAM activity analysis
	•	Network anomalies
	•	Compliance reporting
	•	Real-time alerting via monitors
	•	Integrated with Security Hub and GuardDuty

⸻

Athena-Based Security Analytics

Predefined SQL views enable structured investigations.

GuardDuty Findings View:
	CREATE VIEW security_guardduty_findings AS
	SELECT
			time,
			severity,
			finding_type,
			activity_name,
			resource_type,
			resource_uid,
			account_uid,
			region
	FROM amazon_security_lake_glue_db.amazon_guardduty_finding;

Privileged Activity Monitoring
	CREATE VIEW security_privileged_activity AS
	SELECT
			time,
			operation,
			identity_type,
			principal,
			source_ip,
			account_uid,
			region
	FROM amazon_security_lake_glue_db.amazon_cloudtrail
	WHERE user_identity.type IN ('Root','AssumedRole');

Additional views cover:
•	Terraform state access auditing
•	VPC traffic anomaly detection

⸻

🏢 Multi-Account AWS Organization

Accounts
	•	Management – Organization administration
	•	Security – GuardDuty, Security Hub, OpenSearch
	•	Logging – Centralised CloudTrail and Flow Logs
	•	Workload – Application infrastructure

Guardrails
	•	Service Control Policies (SCPs)
	•	Root account usage denial
	•	Cross-account access restrictions

⸻

🧰 Terraform Design

Infrastructure as Code
	•	Modular Terraform structure
	•	Remote state with locking
	•	Environment separation via workspaces
	•	Security-focused modules for:
	•	Security Lake
	•	OpenSearch
	•	Monitoring and alerting

Backend & State Security
	•	S3 remote backend
	•	DynamoDB state locking
	•	KMS encryption
	•	Restricted access to CI/CD roles only

terraform-secure-aws-platform/
├── org/            # Organizations, SCPs, GuardDuty, Security Hub
├── network/        # VPCs, subnets, routing, NACLs
├── security/       # IAM, KMS, WAF, ACM
├── compute/        # ALB, ASG, launch templates
├── database/       # RDS and subnet groups
├── backend.tf
├── variables.tf
├── outputs.tf
└── README.md

🎯 Why This Project Matters

This project demonstrates:
	•	Real SOC-style cloud security operations
	•	Threat-driven detection engineering
	•	Practical use of AWS Security Lake
	•	OpenSearch-based security analytics
	•	Severity-based alert escalation
	•	MITRE ATT&CK alignment
	•	Operational resilience through DLQ monitoring

It shows not just how to deploy infrastructure, but how to secure, monitor, and operate it in production.

⸻

📝 Author Notes

This project was built to demonstrate depth over breadth.
Every service included has a clear operational or security purpose and reflects how real production platforms are designed and run.

⸻

🚀 Future Improvements
	•	AWS Backup (cross-account)
	•	AWS Config rules
	•	Control Tower integration
	•	ECS / EKS workloads
