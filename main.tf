module "networking" {
  source              = "./networking"
  public_sn_count     = var.public_sn_count
  private_subnet_cidr = [for i in range(1, 255, 2) : cidrsubnet(var.cidr_block, 8, i)]
  public_subnet_cidr  = [for i in range(2, 255, 2) : cidrsubnet(var.cidr_block, 8, i)]
  security_groups     = local.security_groups
  private_sn_count    = var.private_sn_count
  cidr_block          = var.cidr_block
}

module "compute" {
  source = "./compute"

  instance_count  = 1
  instance_type   = "t2.micro"
  public_sg       = [module.networking.all_sg, module.networking.server_sg]
  public_subnet   = module.networking.public_subnet
  vol_size        = 8
  public_key_path = "prom_server_rsa.pub"
  key_name        = "prom_server_rsa"

}

module "loadbalancing" {
  source = "./loadbalancing"
  vpc_id = module.networking.vpc_id
  public_subnet = module.networking.public_subnet
  lb_sg = module.networking.lb_sg
  instance_count = 1
  instance_id = module.compute.ids
}

module "route53" {
  source = "./route53"
  lb_dns = module.loadbalancing.lb_dns
}