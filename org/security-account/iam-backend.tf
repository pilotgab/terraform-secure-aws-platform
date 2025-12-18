####################################################
# IAM POLICY and ROLE FOR TERRAFORM BACKEND ACCESS
###################################################
resource "aws_iam_policy" "terraform_backend" {
  name        = "terraform-backend-access"
  description = "Restrict access to Terraform remote state and locking table"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "arn:aws:s3:::aws-3-tier-state/*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = "arn:aws:s3:::aws-3-tier-state"
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem"
        ]
        Resource = aws_dynamodb_table.tf_lock.arn
      }
    ]
  })
}

resource "aws_iam_role" "terraform_backend" {
  name = "TerraformBackendRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::${var.workload_account_id}:root"
      }
      Action = "sts:AssumeRole"
      Condition = {
        Bool = {
          "aws:MultiFactorAuthPresent" = "true"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "terraform_backend" {
  role       = aws_iam_role.terraform_backend.name
  policy_arn = aws_iam_policy.terraform_backend.arn
}
