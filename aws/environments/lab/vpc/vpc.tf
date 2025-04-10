locals {
  global_tags = {
    Env     = var.global_vars.env
    Project = var.global_vars.project
    Owner   = var.global_vars.owner
  }
}

resource "aws_vpc" "lab_vpc" {
  cidr_block           = var.cidr_block_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    { Name = "${var.global_vars.env}-vpc" },
    local.global_tags
  )
}

resource "aws_subnet" "lab_sub_private_a" {
  vpc_id            = aws_vpc.lab_vpc.id
  cidr_block        = var.private_subnet_cidrs[0]
  availability_zone = "eu-north-1a"

  tags = merge(
    { Name = "${var.global_vars.env}-${var.subnet_names[0]}" },
    local.global_tags
  )
}

resource "aws_subnet" "lab_sub_private_b" {
  vpc_id            = aws_vpc.lab_vpc.id
  cidr_block        = var.private_subnet_cidrs[1]
  availability_zone = "eu-north-1b"

  tags = merge(
    { Name = "${var.global_vars.env}-${var.subnet_names[1]}" },
    local.global_tags
  )
}