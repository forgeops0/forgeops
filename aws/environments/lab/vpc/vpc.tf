
resource "aws_vpc" "lab" {
  cidr_block           = var.cidr_block_vpc
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(var.global_vars, {
    Name = "${var.global_vars.env}-${var.global_vars.project}-vpc"
  })
}

resource "aws_internet_gateway" "igw" {
  count  = var.create_public_subnets ? 1 : 0
  vpc_id = aws_vpc.lab.id

  tags = merge(var.global_vars, {
    Name = "${var.global_vars.env}-${var.global_vars.project}-igw"
  })
}

resource "aws_subnet" "public" {
  for_each = var.create_public_subnets ? var.public_subnets : {}

  vpc_id                  = aws_vpc.lab.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = merge(var.global_vars, {
    Name = "${var.global_vars.env}-${var.global_vars.project}-${each.key}"
  })
}

resource "aws_subnet" "private" {
  for_each = var.private_subnets

  vpc_id            = aws_vpc.lab.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = merge(var.global_vars, {
    Name = "${var.global_vars.env}-${var.global_vars.project}-${each.key}"
  })
}