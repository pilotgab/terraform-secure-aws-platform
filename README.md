Secure Multi-Account AWS 3-Tier Platform (Terraform)

📌 Overview

This project provisions a secure, scalable, and enterprise-ready AWS platform using Terraform. It is designed to demonstrate real-world DevSecOps and Cloud Security best practices aligned with the AWS Well-Architected Framework, AWS Security Specialty expectations, and patterns commonly used by UK enterprises and regulated environments.

The platform combines:
	•	A secure 3-tier application architecture
	•	A multi-account AWS Organization
	•	Centralised logging, threat detection, and compliance monitoring
	•	Infrastructure-as-Code with remote state, locking, and modular design

This repository is intended as a portfolio-grade project, not a tutorial.

⸻

🏗️ High-Level Architecture

Users
 ↓
Route 53 (www.pilotgabapp.com)
 ↓
Application Load Balancer (Public, HTTPS via ACM)
 ↓
AWS WAF (OWASP Top 10 protection)
 ↓
Auto Scaling App Tier (Private Subnets)
 ↓
Amazon RDS (Private, KMS Encrypted)

ORGANISATION LAYER
AWS Organizations
 ├── Logging Account
 │    └── CloudTrail (Org-wide)
 ├── Security Account
 │    ├── GuardDuty (Org-wide)
 │    └── Security Hub (CIS Benchmarks)
 └── SCP Guardrails


⸻

🔐 Key Security Principles Applied
	•	Least Privilege IAM – minimal permissions for compute and services
	•	Network Isolation – public, application, and database tiers fully separated
	•	Encryption Everywhere – KMS for RDS, encrypted S3 buckets, encrypted state
	•	Defense in Depth – ALB + WAF + private workloads
	•	Centralised Visibility – org-wide logging and threat detection
	•	Compliance by Design – CIS AWS Foundations Benchmark

⸻

🚀 Core Components

1️⃣ Secure 3-Tier Architecture
	•	Public Application Load Balancer
	•	Private application tier running in an Auto Scaling Group
	•	Private RDS database (no public access)
	•	Security Groups enforcing tier-to-tier communication only
	•	Explicit Network ACLs for subnet-level control

2️⃣ DNS & Secure Access
	•	Route 53 hosted zone and ALIAS records
	•	Custom domain: www.pilotgabapp.com
	•	ACM-managed TLS certificates (DNS validated)
	•	HTTPS enforced at the ALB

3️⃣ Web Application Firewall (WAF)
	•	AWS WAFv2 attached to the ALB
	•	AWS Managed Rules (OWASP Top 10)
	•	WAF logging streamed to:
	•	CloudWatch Logs (real-time visibility)
	•	Amazon S3 via Kinesis Firehose (long-term retention)

4️⃣ Scalability & Availability
	•	Application tier deployed using Launch Templates
	•	Auto Scaling Group across multiple Availability Zones
	•	ALB health checks and target groups

⸻

🏢 Multi-Account AWS Organization

The platform uses AWS Organizations to reduce blast radius and enforce governance.

Accounts
	•	Logging Account – centralised CloudTrail logs
	•	Security Account – GuardDuty and Security Hub

Guardrails
	•	Service Control Policies (SCPs) to restrict risky actions
	•	Denial of root account usage

⸻

🔍 Monitoring, Logging & Compliance

CloudTrail (Org-Wide)
	•	Centralised audit logging
	•	Covers all accounts and regions

GuardDuty (Org-Wide)
	•	Continuous threat detection
	•	Auto-enabled for all current and future accounts created the organization

Suecrity Hub
	•	CIS AWS Foundations Benchmark enabled
	•	Continuous compliance posture monitoring

⸻

🧰 Terraform Design

Infrastructure as Code
	•	Modular Terraform structure
	•	Reusable components (network, security, compute, org)

Remote State Backend
	•	S3 backend: aws-3-tier-state
	•	State versioning enabled
	•	DynamoDB table for state locking
	•	Encryption at rest

This supports team-safe and production-grade deployments.

⸻

📁 Repository Structure

terraform-secure-aws-platform/
├── org/                 # AWS Organizations, SCPs, GuardDuty, Security Hub
├── network/             # VPC, subnets, routing, NACLs
├── security/            # IAM, KMS, ACM, WAF
├── compute/             # ALB, Auto Scaling Group, launch templates
├── database/            # RDS and subnet groups
├── backend.tf           # Remote Terraform backend
├── variables.tf
├── outputs.tf
└── README.md


⸻

▶️ Deployment Notes

⚠️ Important: Terraform backends must be bootstrapped before use.

	1.	Create S3 backend and DynamoDB lock table
	2.	Re-initialise Terraform with remote backend
	3.	Apply infrastructure modules

Always review plans before applying.

⸻

🎯 Why This Project Matters

This architecture mirrors patterns used in:
	•	Financial institutions
	•	Regulated enterprises
	•	Cloud-native platforms

It demonstrates practical experience in:
	•	DevSecOps
	•	Cloud Security Engineering
	•	Secure AWS Architecture

⸻

📌 Skills Demonstrated
	•	Terraform (advanced, modular, remote state)
	•	AWS Networking & Security
	•	IAM least privilege design
	•	Cloud-native security controls
	•	Organization-wide governance
	•	Production-grade observability

⸻

🧠 Author Notes
This project was built to demonstrate depth, not breadth. Every service included serves a clear security or reliability purpose and reflects how real production systems are designed and operated.
