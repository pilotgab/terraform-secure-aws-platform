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
