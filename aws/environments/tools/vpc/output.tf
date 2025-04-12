output "vpc_id" {
  value = aws_vpc.tools_vpc.id
}

output "public_subnet_ids" {
  value = values(aws_subnet.tools_public)[*].id
}