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

  # Backup configuration
  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "mon:04:00-mon:05:00"

  # Enable automated minor version upgrades
  auto_minor_version_upgrade = true

  # Enable deletion protection for production
  deletion_protection = true  # Set to false for none-production

  # Skip final snapshot for development (set to true for none-production)
  skip_final_snapshot = false

  tags = {
    Name        = "postgres-db"
    Environment = "production"
  }
}
