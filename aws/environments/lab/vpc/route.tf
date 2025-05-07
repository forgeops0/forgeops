
resource "aws_route_table" "public" {
  count  = var.create_public_subnets ? 1 : 0
  vpc_id = aws_vpc.lab.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[0].id
  }

  tags = merge(var.global_vars, {
    Name = "${var.global_vars.env}-${var.global_vars.project}-public-rt"
  })
}

resource "aws_route_table_association" "public" {
  for_each = var.create_public_subnets ? aws_subnet.public : {}

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public[0].id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.lab.id

  tags = merge(var.global_vars, {
    Name = "${var.global_vars.env}-${var.global_vars.project}-private-rt"
  })
}

resource "aws_route" "nat_default" {
  count                  = var.create_nat_instance ? 1 : 0
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_network_interface.nat[0].id
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}