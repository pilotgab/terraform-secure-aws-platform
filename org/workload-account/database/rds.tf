############################################################
# DATABASE (PRIVATE, ENCRYPTED RDS)
############################################################

resource "aws_db_instance" "postgres" {
  engine               = "postgres"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  username             = var.db_user
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.db.name
  vpc_security_group_ids = [aws_security_group.db.id]
  storage_encrypted    = true
  kms_key_id           = aws_kms_key.rds.arn
  publicly_accessible  = false
}
