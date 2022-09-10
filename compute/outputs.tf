output "ip" {
  value = aws_instance.prom-graf-server.*.public_ip
}

output "ids" {
  value = aws_instance.prom-graf-server.*.id
}