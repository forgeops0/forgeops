// ---------------------------
// File: main.tf
// ---------------------------

terraform {
  required_version = ">= 1.4.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "spaceops-terraform-state"
    key            = "aws/environments/lab/vpc/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}

provider "aws" {
  region = "eu-north-1"
}

// ---------------------------
// File: variables.tf
// ---------------------------

variable "global_vars" {
  type = object({
    env     = string
    project = string
    owner   = string
  })
}

variable "cidr_block_vpc" {
  type = string
}

variable "enable_dns_support" {
  type    = bool
  default = true
}

variable "enable_dns_hostnames" {
  type    = bool
  default = true
}

variable "create_public_subnets" {
  type    = bool
  default = true
}

variable "create_nat_instance" {
  type    = bool
  default = true
}

variable "public_subnets" {
  type = map(object({
    cidr = string
    az   = string
  }))
}

variable "private_subnets" {
  type = map(object({
    cidr = string
    az   = string
  }))
}

variable "nat_instance_config" {
  type = object({
    ami           = string
    instance_type = string
    private_ip    = string
    key_name      = string
    volume_size   = number
    volume_type   = string
  })
}

// ---------------------------
// File: outputs.tf
// ---------------------------

output "vpc_id" {
  value = aws_vpc.lab.id
}

output "private_subnet_ids" {
  value = values(aws_subnet.private)[*].id
}

output "public_subnet_ids" {
  value = try(values(aws_subnet.public)[*].id, [])
}

output "nat_instance_id" {
  value = try(aws_instance.nat[0].id, null)
}

output "nat_eip" {
  value = try(aws_eip.nat[0].public_ip, null)
}

// ---------------------------
// File: vpc.tf
// ---------------------------

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

resource "aws_eip" "nat" {
  count  = var.create_nat_instance ? 1 : 0
  domain = "vpc"

  tags = merge(var.global_vars, {
    Name = "${var.global_vars.env}-${var.global_vars.project}-nat-eip"
  })
}

resource "aws_network_interface" "nat" {
  count           = var.create_nat_instance ? 1 : 0
  subnet_id       = values(aws_subnet.public)[0].id
  private_ips     = [var.nat_instance_config.private_ip]
  security_groups = []

  tags = merge(var.global_vars, {
    Name = "${var.global_vars.env}-${var.global_vars.project}-nat-eni"
  })
}

resource "aws_instance" "nat" {
  count                         = var.create_nat_instance ? 1 : 0
  ami                           = var.nat_instance_config.ami
  instance_type                 = var.nat_instance_config.instance_type
  subnet_id                     = values(aws_subnet.public)[0].id
  associate_public_ip_address   = true
  key_name                      = var.nat_instance_config.key_name
  source_dest_check             = false

  tags = merge(var.global_vars, {
    Name = "${var.global_vars.env}-${var.global_vars.project}-nat-ec2"
  })

  ebs_block_device {
    device_name           = "/dev/xvda"
    volume_size           = var.nat_instance_config.volume_size
    volume_type           = var.nat_instance_config.volume_type
    delete_on_termination = true
  }

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.nat[0].id
  }
}

resource "aws_eip_association" "nat" {
  count         = var.create_nat_instance ? 1 : 0
  instance_id   = aws_instance.nat[0].id
  allocation_id = aws_eip.nat[0].id
}

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

