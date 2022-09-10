output "instance_ips" {
  value = module.compute.ip
}

output "lb_dns" {
  value = module.loadbalancing.lb_dns
}