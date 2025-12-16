# compute/ec2.tf (private app tier placeholder)
resource "aws_instance" "app" {
  count         = 2
  ami           = var.ami
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.app[count.index].id
  iam_instance_profile = aws_iam_instance_profile.app.name
  vpc_security_group_ids = [aws_security_group.app.id]
}

resource "aws_iam_instance_profile" "app" {
  role = aws_iam_role.app.name
}
