resource "aws_vpc" "lab_vpc" {
  cidr_block           = var.cidr_block_vpc
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(
    { Name = "${var.global_vars.env}-vpc" },
    local.global_tags
  )
}

resource "aws_subnet" "lab_private" {
  for_each = var.private_subnets

  vpc_id            = aws_vpc.lab_vpc.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

tags = merge(
  { Name = "${var.global_vars.env}-${var.global_vars.project}-${each.key}" },
  local.global_tags
)
}