# Workload Account Infrastructure

This directory contains the Terraform configuration for deploying a standard 3-tier web application architecture within the Workload AWS account. It is designed to be a secure, scalable, and resilient environment for running applications.

## Architecture Overview

The infrastructure consists of the following core components:

- **VPC**: A dedicated Virtual Private Cloud (VPC) to ensure network isolation.
- **Subnets**: The VPC is divided into three tiers across two Availability Zones for high availability:
  - **Public Subnets**: Host the public-facing Application Load Balancer (ALB).
  - **App Subnets**: Host the private application servers, managed by an Auto Scaling Group.
  - **DB Subnets**: Host the private RDS PostgreSQL database.
- **Networking**: Includes Network ACLs for stateless traffic control and Security Groups for stateful filtering between tiers.
- **Compute**: An Auto Scaling Group manages EC2 instances for the application tier, ensuring scalability and self-healing. Instances are configured via a Launch Template.
- **Database**: A managed AWS RDS PostgreSQL instance, encrypted at rest using a dedicated KMS key.
- **Load Balancing**: An Application Load Balancer (ALB) distributes incoming HTTPS traffic to the application tier.
- **Security**: Includes IAM roles with least-privilege permissions, security groups, and integration with AWS WAF (Web Application Firewall).
- **DNS**: A Route 53 record is created to point a custom domain to the ALB.

## Prerequisites

Before applying this configuration, you must have the following outputs from the `security-account` infrastructure:

- `vpc_flow_logs_bucket_arn`: The ARN of the S3 bucket where VPC Flow Logs will be sent.
- `vpc_flow_logs_role_arn`: The ARN of the IAM Role that allows the VPC Flow Log service to write to the S3 bucket.

## Input Variables

This module requires the following variables to be set. It is recommended to use a `terraform.tfvars` file at the root of the project to provide these values.

| Variable Name                | Description                                                                 | Example                                           |
| ---------------------------- | --------------------------------------------------------------------------- | ------------------------------------------------- |
| `security_account_id`        | The AWS Account ID of the Security account for the backend role ARN.        | `"111122223333"`                                  |
| `acm_certificate_arn`        | The ARN of the ACM certificate for the Application Load Balancer.           | `"arn:aws:acm:us-east-1:ACCOUNT_ID:certificate/CERT_ID"` |
| `ami`                        | The AMI ID for the EC2 instances in the Auto Scaling Group.                 | `"ami-0c55b159cbfafe1f0"`                        |
| `vpc_flow_logs_bucket_arn`   | The ARN of the S3 bucket for VPC flow logs (output from `security-account`).| `"arn:aws:s3:::central-flow-logs-bucket"`         |
| `vpc_flow_logs_role_arn`     | The ARN of the IAM role for VPC flow logs (output from `security-account`). | `"arn:aws:iam::ACCOUNT_ID:role/flow-logs-role"`   |
| `db_user`                    | The username for the RDS PostgreSQL database.                               | `"admin"`                                       |
| `db_password`                | The password for the RDS database. **(Should be kept secure)**              | `"YourSecurePassword123!"`                      |

## Usage

1.  **Initialize Terraform**:
    ```sh
    terraform init
    ```

2.  **Plan the Deployment**:
    Ensure you have a `terraform.tfvars` file in the root directory with the required variable values.
    ```sh
    terraform plan
    ```

3.  **Apply the Configuration**:
    ```sh
    terraform apply
    ```
