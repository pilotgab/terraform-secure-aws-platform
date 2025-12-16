############################################################
# SECURITY LAKE – DATA LAKE
############################################################
resource "aws_securitylake_data_lake" "main" {
  meta_store_manager_role_arn = aws_iam_role.security_lake_metastore.arn
}
