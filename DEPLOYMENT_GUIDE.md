# Deployment Guide - Secure Multi-Account AWS Platform

## Prerequisites

1. **AWS Account Setup**
   - Root AWS account with Organizations enabled
   - Valid email addresses for each sub-account (must be unique)
   - AWS CLI configured with credentials for the management account
   - Terraform >= 1.5.0 installed

2. **Required Information**
   - Security Account ID (will be obtained after step 1)
   - Logging Account ID (will be obtained after step 1)
   - Workload Account ID (will be obtained after step 1)

---

## Deployment Sequence

### Phase 1: Create Organization and Accounts

**Location:** `org/management/`

1. Navigate to the management directory:
   ```bash
   cd org/management
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Update `terraform.tfvars` with your email addresses:
   ```hcl
   security_email  = "security@yourdomain.com"
   logging_email   = "logging@yourdomain.com"
   workload_email  = "workload@yourdomain.com"
   ```

4. Plan and apply:
   ```bash
   terraform plan
   terraform apply
   ```

5. **IMPORTANT:** Note the account IDs from the output:
   ```bash
   terraform output security_account_id
   terraform output logging_account_id
   terraform output workload_account_id
   ```

---

### Phase 2: Bootstrap Backend in Security Account

**Location:** `org/security-account/`

1. **Update backend configuration files** with the actual Security Account ID:

   In `org/logging-account/backend.tf`:
   ```hcl
   role_arn = "arn:aws:iam::<ACTUAL_SECURITY_ACCOUNT_ID>:role/TerraformBackendRole"
   ```

   In `org/workload-account/backend.tf`:
   ```hcl
   role_arn = "arn:aws:iam::<ACTUAL_SECURITY_ACCOUNT_ID>:role/TerraformBackendRole"
   ```

2. Navigate to security account directory:
   ```bash
   cd org/security-account
   ```

3. **First Run - Bootstrap Backend (Local State)**

   Comment out the backend block in `backend.tf` temporarily:
   ```hcl
   # terraform {
   #   backend "s3" {
   #     ...
   #   }
   # }
   ```

4. Initialize and apply to create S3 bucket and DynamoDB table:
   ```bash
   terraform init
   terraform apply -target=aws_s3_bucket.tf_state \
                   -target=aws_s3_bucket.tf_state_logs \
                   -target=aws_dynamodb_table.tf_lock
   ```

5. **Second Run - Migrate to Remote Backend**

   Uncomment the backend block in `backend.tf`

   Re-initialize to migrate state:
   ```bash
   terraform init -migrate-state
   ```

   Answer "yes" when prompted to migrate state.

6. Update `terraform.tfvars`:
   ```hcl
   workload_account_id = "<WORKLOAD_ACCOUNT_ID_FROM_PHASE_1>"
   ```

7. Apply remaining security account resources:
   ```bash
   terraform apply
   ```

8. Note the VPC flow logs bucket ARN:
   ```bash
   terraform output vpc_flow_logs_bucket_arn
   ```

---

### Phase 3: Deploy Logging Account

**Location:** `org/logging-account/`

1. Navigate to logging account directory:
   ```bash
   cd org/logging-account
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Apply:
   ```bash
   terraform apply
   ```

---

### Phase 4: Deploy Workload Account

**Location:** `org/workload-account/`

1. Navigate to workload account directory:
   ```bash
   cd org/workload-account
   ```

2. Update `terraform.tfvars`:
   ```hcl
   security_account_id       = "<SECURITY_ACCOUNT_ID>"
   ami                       = "ami-xxxxxxxxx"  # Amazon Linux 2 AMI for your region
   vpc_flow_logs_bucket_arn  = "<VPC_FLOW_LOGS_BUCKET_ARN_FROM_PHASE_2>"
   db_user                   = "dbadmin"
   db_password               = "YourSecurePassword123!"  # Use AWS Secrets Manager in production
   acm_certificate_arn       = ""  # Will be created automatically
   ```

3. Initialize Terraform:
   ```bash
   terraform init
   ```

4. Apply in stages to handle dependencies:

   **Stage 1: Networking**
   ```bash
   terraform apply -target=module.networking
   ```

   **Stage 2: Security (ACM, KMS, Security Groups)**
   ```bash
   terraform apply -target=module.security
   ```

   **Stage 3: Database**
   ```bash
   terraform apply -target=module.database
   ```

   **Stage 4: Compute (ALB, ASG)**
   ```bash
   terraform apply -target=module.compute
   ```

   **Stage 5: DNS**
   ```bash
   terraform apply -target=module.dns
   ```

   **Final: Apply all remaining resources**
   ```bash
   terraform apply
   ```

---

## Provider Configuration for Cross-Account Access

### Important Note on Provider Configuration

Each account module needs to assume a role in the target account. Add provider configurations as follows:

#### Security Account
Create `org/security-account/provider.tf`:
```hcl
provider "aws" {
  region = "us-east-1"

  assume_role {
    role_arn = "arn:aws:iam::<SECURITY_ACCOUNT_ID>:role/OrganizationAccountAccessRole"
  }
}
```

#### Logging Account
Create `org/logging-account/provider.tf`:
```hcl
provider "aws" {
  region = "us-east-1"

  assume_role {
    role_arn = "arn:aws:iam::<LOGGING_ACCOUNT_ID>:role/OrganizationAccountAccessRole"
  }
}
```

#### Workload Account
Create `org/workload-account/provider.tf`:
```hcl
provider "aws" {
  region = "us-east-1"

  assume_role {
    role_arn = "arn:aws:iam::<WORKLOAD_ACCOUNT_ID>:role/OrganizationAccountAccessRole"
  }
}
```

**Note:** The `OrganizationAccountAccessRole` is automatically created by AWS Organizations when you create a new account.

---

## Post-Deployment Steps

1. **Verify Resources**
   ```bash
   # Check ALB DNS name
   terraform output alb_dns_name

   # Check Route53 hosted zone
   terraform output route53_zone_id
   ```

2. **Update DNS**
   - Point your domain's nameservers to the Route53 hosted zone NS records

3. **Application Files** (Automated via Terraform)
   - Application files are automatically uploaded from `org/workload-account/web-app/` directory
   - Ensure you have your application files in this directory before running `terraform apply`
   - If you need to update files after deployment, modify them and run `terraform apply` again
   - Alternatively, you can manually upload: `aws s3 sync ./your-app-files s3://pilotgab-web-app/`

4. **Test the Application**
   - Access via ALB DNS name or your custom domain
   - Verify HTTPS is working
   - Check WAF logs in CloudWatch

5. **Enable Production Settings**
   - Set `deletion_protection = true` for ALB and RDS
   - Set `skip_final_snapshot = false` for RDS
   - Enable ALB access logs
   - Review and adjust Auto Scaling policies

---

## Troubleshooting

### Issue: "Error assuming role"
**Solution:** Ensure the OrganizationAccountAccessRole exists in the target account and your management account has permission to assume it.

### Issue: "Backend initialization failed"
**Solution:** Verify the S3 bucket and DynamoDB table exist in the security account and you have the correct role_arn configured.

### Issue: "VPC has no internet connectivity"
**Solution:** Verify Internet Gateway and NAT Gateways are created and route tables are properly associated.

### Issue: "ACM certificate validation timeout"
**Solution:** Ensure Route53 hosted zone is created first and DNS validation records are added.

### Issue: "EC2 instances can't access S3"
**Solution:** Verify the IAM instance profile is attached and has both s3:GetObject and s3:ListBucket permissions.

---

## Security Considerations

1. **Secrets Management**
   - Never commit `terraform.tfvars` to version control
   - Use AWS Secrets Manager for database passwords in production
   - Rotate credentials regularly

2. **State File Security**
   - State files contain sensitive data
   - S3 bucket has encryption enabled
   - Access is restricted via IAM policies

3. **MFA Requirement**
   - The TerraformBackendRole requires MFA
   - Ensure MFA is enabled on your AWS account

4. **Network Security**
   - Review Security Group rules
   - Verify NACLs are properly configured
   - Enable VPC Flow Logs monitoring

---

## Cleanup

To destroy all resources (in reverse order):

```bash
# Workload Account
cd org/workload-account
terraform destroy

# Logging Account
cd org/logging-account
terraform destroy

# Security Account (except backend)
cd org/security-account
terraform destroy -target=aws_guardduty_detector.org
# ... destroy other resources except S3 and DynamoDB

# Management Account
cd org/management
terraform destroy
```

**Note:** S3 buckets with `prevent_destroy = true` must be manually deleted after removing the lifecycle rule.

---

## Support

For issues or questions:
1. Check AWS CloudWatch Logs for application errors
2. Verify IAM permissions and role assumptions
3. Review Terraform state for resource dependencies

---
