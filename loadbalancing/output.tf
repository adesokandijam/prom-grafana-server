output "lb_dns" {
  value = aws_lb.prom_server_lb.dns_name
}