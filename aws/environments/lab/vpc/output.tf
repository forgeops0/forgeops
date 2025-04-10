###
output "private_subnet_ids" {
  value = values(aws_subnet.lab_private)[*].id
}