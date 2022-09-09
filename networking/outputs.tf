output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "public_subnet" {
  value = aws_subnet.public_subnet.*.id
}

output "public_sg" {
  value = aws_security_group.all_sg["public"].id
}