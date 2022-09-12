output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "public_subnet" {
  value = aws_subnet.public_subnet.*.id
}

output "lb_sg" {
  value = aws_security_group.lb_sg.id
}

output "all_sg" {
  value = aws_security_group.all_sg["ssh"].id
}

output "server_sg" {
  value = aws_security_group.server_sg.id
}

output "http_sg" {
  value = aws_security_group.lb_sg_http.id
}