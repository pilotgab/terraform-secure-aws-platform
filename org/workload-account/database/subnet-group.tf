resource "aws_db_subnet_group" "db" {
  name       = "db-subnet-group"
  subnet_ids = aws_subnet.db[*].id

  tags = {
    Name = "db-subnet-group"
    Tier = "database"
  }
}
