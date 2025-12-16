# Security Account Infrastructure

This directory contains the Terraform configuration for the central Security AWS account. This account serves as the dedicated hub for all security-related services, tooling, monitoring, and response activities. Isolating security functions in a separate account is a fundamental best practice for building a secure and compliant cloud environment.

## Architecture Overview

The security account is designed to provide a centralized platform for threat detection, security analytics, and posture management. The key components include:

- **Secure Terraform Backend**: Deploys a dedicated S3 bucket and a DynamoDB table to provide a secure, centralized, and lockable backend for managing Terraform state across all accounts.
- **AWS Security Lake**: A centralized security data lake is established to aggregate, normalize, and store security data from various sources across the entire AWS Organization.
- **Amazon GuardDuty**: Enabled as an organization-wide delegated administrator, GuardDuty provides intelligent threat detection by continuously monitoring for malicious activity and unauthorized behavior.
- **AWS Security Hub**: Deployed to provide a comprehensive view of the security posture. It centralizes security alerts from various AWS services and runs automated compliance checks against security standards like the CIS AWS Foundations Benchmark.
- **Amazon OpenSearch**: A managed OpenSearch cluster is provisioned for security analytics, enabling advanced querying, visualization, and dashboarding of security data collected by Security Lake.
- **Centralized VPC Flow Logs Bucket**: An S3 bucket is created to be the central destination for VPC Flow Logs from all accounts, enabling network traffic analysis.
- **IAM Roles & Policies**: Defines least-privilege IAM roles for cross-account access (e.g., the `TerraformBackendRole` for other accounts to assume) and for services to function correctly.
- **Service Control Policies (SCPs)**: Implements preventative guardrails at the organization level, such as a policy to deny all actions from the root user, enforcing the use of IAM roles.
- **SOC Alerting & Dashboards**: Includes configurations for creating security dashboards in OpenSearch and setting up alerting mechanisms for the Security Operations Centre (SOC).

## Input Variables

This module requires the following variable:

| Variable Name         | Description                                                          | Example          |
| --------------------- | -------------------------------------------------------------------- | ---------------- |
| `workload_account_id` | The AWS Account ID of the Workload account to grant backend access.  | `"444455556666"` |

## Outputs

This configuration generates the following critical outputs, which are intended to be used as inputs for other accounts (like the `workload-account`):

| Output Name                  | Description                                                              |
| ---------------------------- | ------------------------------------------------------------------------ |
| `vpc_flow_logs_bucket_arn`   | The ARN of the central S3 bucket for storing VPC Flow Logs.              |
| `vpc_flow_logs_role_arn`     | The ARN of the IAM role that grants permissions to write to the bucket.  |

## Usage

1.  **Bootstrap Backend (First-Time Setup)**:
    Apply the `backend-bootstrap.tf` configuration once to create the S3 bucket and DynamoDB table.
    ```sh
    terraform init
    terraform apply -target=aws_s3_bucket.tf_state -target=aws_dynamodb_table.tf_lock
    ```

2.  **Initialize Terraform**:
    After the backend is created, initialize the main configuration.
    ```sh
    terraform init
    ```

3.  **Plan and Apply**:
    Review and apply the rest of the security infrastructure.
    ```sh
    terraform plan
    terraform apply
    ```
