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