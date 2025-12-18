############################################################
# INTERNET GATEWAY (PUBLIC SUBNETS)
############################################################
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

############################################################
# ELASTIC IPs FOR NAT GATEWAYS
############################################################
resource "aws_eip" "nat" {
  count  = 2
  domain = "vpc"

  tags = {
    Name = "nat-eip-${count.index + 1}"
  }

  depends_on = [aws_internet_gateway.main]
}

############################################################
# NAT GATEWAYS (PRIVATE SUBNET INTERNET ACCESS)
############################################################
resource "aws_nat_gateway" "main" {
  count         = 2
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "nat-gateway-${count.index + 1}"
  }

  depends_on = [aws_internet_gateway.main]
}
