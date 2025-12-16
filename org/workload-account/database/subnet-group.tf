resource "aws_db_subnet_group" "db" {
  subnet_ids = aws_subnet.db[*].id
}
