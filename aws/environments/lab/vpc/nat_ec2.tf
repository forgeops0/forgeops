
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
  security_groups = [aws_security_group.nat.id]

  tags = merge(var.global_vars, {
    Name = "${var.global_vars.env}-${var.global_vars.project}-nat-eni"
  })
}

resource "aws_instance" "nat" {
  count                         = var.create_nat_instance ? 1 : 0
  ami                           = var.nat_instance_config.ami
  instance_type                 = var.nat_instance_config.instance_type
  #subnet_id                     = values(aws_subnet.public)[0].id
  #associate_public_ip_address   = true
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

  # network_interface {
  #   device_index         = 0
  #   network_interface_id = aws_network_interface.nat[0].id
  # }
}

resource "aws_eip_association" "nat" {
  count         = var.create_nat_instance ? 1 : 0
  instance_id   = aws_instance.nat[0].id
  allocation_id = aws_eip.nat[0].id
}
