# (baseline security guardrail)
resource "aws_organizations_policy" "deny_root" {
  name = "deny-root-usage"
  type = "SERVICE_CONTROL_POLICY"
  content = jsonencode({
    Version = "2012-10-17",
    Statement = [{ Effect = "Deny", Action = "*", Resource = "*", Condition = { StringLike = { "aws:PrincipalArn" = "arn:aws:iam::*:root" } } }]
  })
}

resource "aws_organizations_policy_attachment" "security_attach" {
  policy_id = aws_organizations_policy.deny_root.id
  target_id = aws_organizations_account.security.id
}

resource "aws_organizations_policy" "deny_local_state" {
  name = "DenyLocalTerraformState"
  type = "SERVICE_CONTROL_POLICY"

  content = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid    = "DenyDirectS3StateCreationOutsideBackend"
      Effect = "Deny"
      Action = [
        "s3:CreateBucket"
      ]
      Resource = "*"
      Condition = {
        StringNotEquals = {
          "aws:PrincipalArn" = "arn:aws:iam::*:role/TerraformBackendRole"
        }
      }
    }]
  })
}
