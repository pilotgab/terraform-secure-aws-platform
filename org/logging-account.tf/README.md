# Logging Account Infrastructure

This directory contains the Terraform configuration for the central Logging AWS account. The primary purpose of this account is to securely aggregate and store logs from all other accounts within the AWS Organization. This centralized model is a security best practice, as it ensures that logs are immutable and isolated from the environments they monitor.

## Architecture Overview

The infrastructure provisioned by this configuration includes the following key components:

- **Centralized S3 Bucket for CloudTrail**: A highly secure and durable S3 bucket is created to serve as the central repository for all AWS CloudTrail logs from across the organization. The bucket is configured with:
  - **Server-Side Encryption (SSE-S3)**: To protect log data at rest.
  - **Lifecycle Policies**: To prevent accidental deletion (`prevent_destroy = true`).
  - **Strict Bucket Policy**: A resource-based policy is attached to the bucket to allow the CloudTrail service to write logs from all accounts in the organization while restricting all other access.

- **Organization-wide AWS CloudTrail**: An AWS CloudTrail trail is configured at the organization level. This single trail automatically captures API activity and events for all member accounts, including the management account. Key features include:
  - **Multi-Region Trail**: Captures events from all AWS regions.
  - **Global Service Events**: Includes events from global services like IAM and Route 53.
  - **Log File Validation**: Ensures the integrity of the log files, confirming they have not been tampered with after delivery.
  - **Data Events**: Configured to monitor critical S3 data events, such as access to the Terraform state bucket.

- **Service Control Policy (SCP)**: An SCP is defined to deny the creation of S3 buckets that could be used for local Terraform state, enforcing the use of the centralized and secure backend.

## Usage

This configuration should be applied from within the `logging-account.tf` directory. It assumes that the AWS provider is configured to operate within the management account, as it needs permissions to manage organization-level resources like CloudTrail and SCPs.

1.  **Initialize Terraform**:
    ```sh
    terraform init
    ```

2.  **Plan the Deployment**:
    Review the planned changes to ensure they are correct.
    ```sh
    terraform plan
    ```

3.  **Apply the Configuration**:
    ```sh
    terraform apply
    ```
