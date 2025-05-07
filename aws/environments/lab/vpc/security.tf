
resource "aws_security_group" "nat" {
  name        = "${var.global_vars.env}-${var.global_vars.project}-nat-sg"
  description = "Security group for NAT EC2 instance"
  vpc_id      = aws_vpc.lab.id

  tags = merge(var.global_vars, {
    Name = "${var.global_vars.env}-${var.global_vars.project}-nat-sg"
  })

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}