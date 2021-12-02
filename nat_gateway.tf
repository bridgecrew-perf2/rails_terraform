resource "aws_eip" "nat_gateway" {
  count = length(var.availability_zones)
  vpc   = true
  depends_on = [
    aws_internet_gateway.example
  ]
}
resource "aws_nat_gateway" "nat_gateway" {
  count         = length(var.availability_zones)
  allocation_id = aws_eip.nat_gateway[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  depends_on    = [aws_internet_gateway.example]
  tags = {
    Name = "${var.r_prefix}-natgw-${var.az[count.index]}"
  }
}