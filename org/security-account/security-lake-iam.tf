############################################################
# SECURITY LAKE – META STORE MANAGER ROLE
############################################################
resource "aws_iam_role" "security_lake_metastore" {
  name = "SecurityLakeMetaStoreManagerRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "securitylake.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "security_lake_metastore" {
  role = aws_iam_role.security_lake_metastore.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "glue:*",
        "s3:*",
        "athena:*"
      ]
      Resource = "*"
    }]
  })
}
