locals {
  global_tags = {
    Env     = var.global_vars.env
    Project = var.global_vars.project
    Owner   = var.global_vars.owner
  }
}

resource "aws_vpc" "tools_vpc" {
  cidr_block           = var.cidr_block_vpc
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(
    { Name = "${var.global_vars.env}-vpc" },
    local.global_tags
  )
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.tools_vpc.id

  tags = merge(
    { Name = "${var.global_vars.env}-${var.global_vars.project}-igw" },
    local.global_tags
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.tools_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    { Name = "${var.global_vars.env}-${var.global_vars.project}-public-rt" },
    local.global_tags
  )
}

resource "aws_subnet" "tools_public" {
  for_each = var.public_subnets

  vpc_id                  = aws_vpc.tools_vpc.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = merge(
    { Name = "${var.global_vars.env}-${var.global_vars.project}-${each.key}" },
    local.global_tags
  )
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.tools_public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}