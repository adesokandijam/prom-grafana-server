output "instance_ips" {
  value = module.compute.ip
}

output "lb_dns" {
  value = module.loadbalancing.lb_dns
}
output "instance_ids" {
  value = module.compute.ids
}