<!-- BEGIN_TF_DOCS -->
# 🚀 Secure Multi-Account AWS Platform with Terraform

A production-ready, security-hardened AWS multi-account infrastructure as code (IaC) implementation with enterprise-grade security controls, comprehensive monitoring, and operational excellence.

📌 Overview

This project provisions a secure, scalable, and enterprise-ready AWS platform using Terraform. It is designed to demonstrate real-world DevSecOps and Cloud Security best practices aligned with the AWS Well-Architected Framework, AWS Security Specialty expectations, and patterns commonly used by UK enterprises and regulated environments.

## 🌟 Key Features

### 🔒 Security First
- **AWS Organizations** with Service Control Policies (SCPs)
- **Multi-account** architecture (Management, Security, Logging, Workload)
- **End-to-end encryption** (EBS, RDS, S3, EFS) with KMS
- **Network security** with VPC, NACLs, and security groups
- **Identity & Access** with IAM roles, MFA enforcement, and least privilege
- **Threat detection** via GuardDuty and Security Hub
- **WAF** with OWASP Top 10 protection

### 🏗 Infrastructure
- **High Availability** across multiple AZs
- **Auto Scaling** for web applications
- **Managed Database** with RDS PostgreSQL
- **Content Delivery** via CloudFront (optional)
- **Centralized Logging** with CloudTrail and VPC Flow Logs

### 📊 Monitoring & Compliance
- **Centralized monitoring** with CloudWatch
- **Security compliance** with CIS benchmarks
- **Audit trails** for all API activity
- **Alerting** via SNS and EventBridge

## 🛡 Security Features

### Network Security
- VPC with public and private subnets
- Network ACLs and security groups
- VPC Flow Logs to S3
- WAF with OWASP Top 10 protection

### Identity & Access
- IAM roles with least privilege
- MFA enforcement
- Password policies
- Cross-account access controls

### Data Protection
- Encryption at rest (KMS, EBS, RDS, S3)
- Encryption in transit (TLS 1.2+)
- Automated backups
- Secrets management

### Monitoring & Compliance
- AWS GuardDuty for threat detection
- Security Hub with CIS Benchmark
- CloudTrail for audit logging
- CloudWatch for monitoring and alerting

## 🚀 Core Components

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

## 🏢 Multi-Account AWS Organization

The platform uses AWS Organizations to reduce blast radius and enforce governance.

Accounts
	•	Logging Account – centralised CloudTrail logs
	•	Security Account – GuardDuty and Security Hub

Guardrails
	•	Service Control Policies (SCPs) to restrict risky actions
	•	Denial of root account usage

## 🔍 Monitoring, Logging & Compliance

CloudTrail (Org-Wide)
	•	Centralised audit logging
	•	Covers all accounts and regions

GuardDuty (Org-Wide)
	•	Continuous threat detection
	•	Auto-enabled for all current and future accounts created the organization

Security Hub
	•	CIS AWS Foundations Benchmark enabled
	•	Continuous compliance posture monitoring

## 🧰 Terraform Design

Infrastructure as Code
	•	Modular Terraform structure
	•	Reusable components (network, security, compute, org)

Remote State Backend
	•	S3 backend: aws-3-tier-state
	•	State versioning enabled
	•	DynamoDB table for state locking
	•	Encryption at rest

## 📂 Project Structure

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

## 🚀 Quick Start

### Prerequisites
- AWS Account with Organizations enabled
- AWS CLI configured with admin access
- Terraform >= 1.5.0
- jq (for helper scripts)

### Deployment Steps
1. Create S3 backend and DynamoDB lock table
2. Re-initialise Terraform with remote backend
3. Apply infrastructure modules

## 🛠 Maintenance

### Upgrading
1. Pull the latest changes
2. Review release notes for breaking changes
3. Run `terraform plan` to preview changes
4. Apply changes with `terraform apply`

### Backup & Recovery
- RDS automated backups with 7-day retention
- S3 versioning enabled
- Point-in-time recovery available

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📝 Author Notes

This project was built to demonstrate depth, not breadth. Every service included serves a clear security or reliability purpose and reflects how real production systems are designed and operated.

## Future Improvements
- [ ] Implement AWS Backup for cross-account backup management
- [ ] Add AWS Config rules for compliance monitoring
- [ ] Implement AWS Control Tower for large-scale deployments
- [ ] Add container orchestration with ECS/EKS
